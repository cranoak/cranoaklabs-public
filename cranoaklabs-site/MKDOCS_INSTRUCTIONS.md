# MKDOCS Setup

## Index 

- [Setup](#setup)
- [Publish AWS S3]
- [Links](#links) 

## setup

Please see [James Willet Mkdocs setup](https://jameswillett.dev/getting-started-with-material-for-mkdocs/) for details.  This shows how to configure VSCode for MKDOCS and Material.

###  Start site after setup
`mkdocs serve`

```
# chekc .gitignore is configured for python
# create venv  environment
python -m venv mkdocs-venv
source mkdocs-venv/bin/activate
pip install mkdocs-material
pip install mkdocs-mermaid2-plugin
# https://pypi.org/project/mknotebooks/
pip install mknotebooks

# cd daves_sample_site/
pwd 
/home/david/git/cranoak/cranoakmono-repo/python-dev-site

mkdocs new .


```
### update mkdocs.yml
 https://github.com/squidfunk/mkdocs-material/discussions/7126

```
plugins:
  - search:
      lang: en
  - mermaid2
```
mkdocs serve

## Publish S3

# publishes site to ./site directory
mkdocs build
# pushes everything to main site
aws s3 sync ./site/ s3://cranoak.org/cranoaklabs/

# optionally publish to test
aws s3 sync ./site/ s3://cranoak.org/cranoaklabs/test/
# view
aws s3 ls s3://cranoak.org/cranoaklabs/
```

- [Publish AWS]
  - [AWS S3](https://dev.to/r_elena_mendez_escobar/deploying-docs-as-code-on-aws-building-dynamic-documentation-sites-in-mkdocs-and-docusaurus-3516)
  - [AWS S3 using CFT](https://github.com/spensireli/mkdocs-static-s3-website)
    - [Using Default Directoy Indexes AWS s3 backed CFT Origins](https://aws.amazon.com/blogs/compute/implementing-default-directory-indexes-in-amazon-s3-backed-amazon-cloudfront-origins-using-lambdaedge/)
      BTW the edge code is from 2017

## Links 

- [James Willett - Material for MkDocs: Full Tutorial To Build And Deploy Your Docs Portal](https://www.youtube.com/watch?v=xlABhbnNrfI)
- [Material GH pages](https://squidfunk.github.io/mkdocs-material/)
- [Apps on Azure Blot](https://techcommunity.microsoft.com/blog/appsonazureblog/deploy-mkdocs-page-on-azure-web-app/4272895)
- [GitHub Pages](https://github.com/mkdocs/mkdocs/blob/master/docs/user-guide/deploying-your-docs.md)
- [Deploying your docs](https://www.mkdocs.org/user-guide/deploying-your-docs/)  
  - GH Pages
  - Read the Docs
  - Any hosting provider which can serve static files
    Using scp, ftp or scp client 