## Publishing MkDocs to Amazon S3

This document explains how to build and publish an MkDocs static site to Amazon S3, with an example GitHub Actions workflow and recommended best practices (CloudFront, cache headers, IAM scope).

### Prerequisites
- Python and MkDocs (or a virtualenv) in your development environment.
- AWS CLI v2 installed and configured with credentials that can access the target S3 bucket (and CloudFront if used).
- `mkdocs.yml` present at the repo root and your site builds into `site/` by default.

Install the basics if needed:

```bash
pip install mkdocs
# optional theme
pip install mkdocs-material
```

Configure AWS credentials (recommended: named profile or CI secrets):

```bash
aws configure --profile deployer
# or set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY in environment
```

### Build the site
From the repository root (where `mkdocs.yml` lives):

```bash
mkdocs build
# or explicitly
mkdocs build -d site
```

### Create or configure the S3 bucket
Option A — simple public S3 website (no HTTPS by default):

```bash
aws s3 mb s3://my-mkdocs-bucket --region us-east-1
aws s3 website s3://my-mkdocs-bucket --index-document index.html --error-document 404.html
```

If you expose the bucket publicly, add a bucket policy that allows public GETs to `arn:aws:s3:::my-mkdocs-bucket/*`.

Option B — recommended: S3 (private) + CloudFront (HTTPS, caching)
- Block public access on the S3 bucket.
- Configure CloudFront with the S3 origin and use an Origin Access Control (OAC) so CloudFront can read from S3.
- Use ACM for TLS and Route 53 for DNS if you want a custom domain.

### Sync files to S3
The simplest deployment:

```bash
aws s3 sync site/ s3://my-mkdocs-bucket --delete --profile deployer
```

Avoid using `--acl public-read` when possible; prefer a bucket policy or CloudFront OAC.

### Recommended cache-control & content-type handling
Best practice:
- HTML files: short cache (no-cache) so updates show quickly.
- Static assets (CSS/JS/images/fonts): long cache (e.g., `max-age=31536000, immutable`) if filenames are content-hashed.

Example small deploy script that syncs then sets metadata for HTML and assets:

```bash
#!/usr/bin/env bash
set -euo pipefail
BUCKET=my-mkdocs-bucket
PROFILE=deployer

# sync everything
aws s3 sync site/ s3://$BUCKET --delete --profile $PROFILE

# set HTML files to no-cache
find site -type f -name '*.html' -print0 | while IFS= read -r -d '' file; do
	key="${file#site/}"
	aws s3 cp "$file" "s3://$BUCKET/$key" --profile $PROFILE \
		--content-type "text/html; charset=utf-8" \
		--cache-control "no-cache, no-store, must-revalidate"
done

# set long cache for static assets
find site -type f \( -name '*.css' -o -name '*.js' -o -name '*.png' -o -name '*.jpg' -o -name '*.svg' -o -name '*.woff2' \) -print0 | while IFS= read -r -d '' file; do
	key="${file#site/}"
	aws s3 cp "$file" "s3://$BUCKET/$key" --profile $PROFILE \
		--cache-control "public, max-age=31536000, immutable"
done
```

This re-uploads files to set metadata (safe when static asset filenames are content-hashed).

### CloudFront invalidation (optional)
If you use CloudFront, after publishing you may need to invalidate cached objects:

```bash
aws cloudfront create-invalidation --distribution-id E123EXAMPLE --paths "/*"
```

Prefer targeted invalidations (e.g., `/index.html`) or rely on cache-control to minimize invalidations.

### Example GitHub Actions workflow
Create `.github/workflows/deploy-mkdocs-s3.yml` with (example):

```yaml
name: Deploy MkDocs to S3

on:
	push:
		branches: [ main ]

jobs:
	deploy:
		runs-on: ubuntu-latest
		steps:
			- uses: actions/checkout@v4

			- name: Setup Python
				uses: actions/setup-python@v4
				with:
					python-version: '3.11'

			- name: Install dependencies
				run: |
					python -m pip install --upgrade pip
					pip install mkdocs mkdocs-material

			- name: Build site
				run: mkdocs build

			- name: Configure AWS credentials
				uses: aws-actions/configure-aws-credentials@v2
				with:
					aws-access-key-id: ${{ secrets.AWS_DEPLOY_KEY_ID }}
					aws-secret-access-key: ${{ secrets.AWS_DEPLOY_SECRET }}
					aws-region: us-east-1

			- name: Sync to S3
				run: |
					aws s3 sync site/ s3://my-mkdocs-bucket --delete

			- name: Invalidate CloudFront
				if: ${{ secrets.CLOUDFRONT_DIST_ID != '' }}
				run: |
					aws cloudfront create-invalidation --distribution-id ${{ secrets.CLOUDFRONT_DIST_ID }} --paths "/*"
```

Store `AWS_DEPLOY_KEY_ID` and `AWS_DEPLOY_SECRET` in GitHub Secrets. Optionally add `CLOUDFRONT_DIST_ID` if you use CloudFront.

### Minimal IAM policy for deploy key
Example IAM policy scoped to a specific S3 bucket and CloudFront invalidation:

```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"s3:ListBucket"
			],
			"Resource": [
				"arn:aws:s3:::my-mkdocs-bucket"
			]
		},
		{
			"Effect": "Allow",
			"Action": [
				"s3:GetObject",
				"s3:PutObject",
				"s3:DeleteObject",
				"s3:PutObjectAcl"
			],
			"Resource": [
				"arn:aws:s3:::my-mkdocs-bucket/*"
			]
		},
		{
			"Effect": "Allow",
			"Action": [
				"cloudfront:CreateInvalidation"
			],
			"Resource": "*"
		}
	]
}
```

Notes: you can remove `s3:PutObjectAcl` if you use bucket policy and do not rely on ACLs.

### Testing
- If S3 website: visit `http://my-mkdocs-bucket.s3-website-<region>.amazonaws.com`.
- If CloudFront/custom domain: visit the CloudFront domain or your custom domain (HTTPS).
- Check headers with `curl -I https://example.com/` to verify `cache-control` and `content-type`.

### Security & best practices (summary)
- Prefer CloudFront + S3 private bucket with OAC for HTTPS and security.
- Use content-hashed asset filenames + long cache for assets.
- Keep HTML short-cached (or use cache-busting) so changes propagate quickly.
- Limit IAM credentials to the minimum required actions and bucket scope.

---

If you'd like, I can also:
- Add CloudFront OAC setup instructions and an example Terraform/Boto3 snippet (todo: add CloudFront distribution and cache invalidation details).
- Create the GitHub Actions workflow file in this repo now.

If you want me to create the workflow file and mark this doc done, reply `Apply workflow` and I'll add `.github/workflows/deploy-mkdocs-s3.yml` and mark the todo item complete.

