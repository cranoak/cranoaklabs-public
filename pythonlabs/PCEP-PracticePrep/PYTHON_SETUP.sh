# Python Environment Setup

## Run Lab after install


source pcep-venv/bin/activate
jupyter-lab --no-browser

pip install jupyterlab-vim
# to deactivate run:  
# close jupyter-lab
ctl-C 
# to close venv
deactivate 
## Installation

The current setup is for the Azure Cloud and Kubernetes Team.  This setup uses:

- WSL and ubuntu
- VSCode 
- Python virtual environments

Jupyter Notebook is used for Python PCEP and PCAP certifications.
- [wsl2](https://learn.microsoft.com/en-us/windows/wsl/install) Please follow directions in the link.
- [VScode windows 11 installation](https://apps.microsoft.com/detail/xp9khm4bk9fz7q?launch=true&mode=full&hl=en-us&gl=us&ocid=bingwebsearch)  VSCode installer is simple .exe

### Python Setup
We are running python on ubuntu on wsl.  

You need python 3.10.12 or higher  
This is tested with 3.10.12  

sudo apt update -y && sudo apt upgrade -y
python --version

## If python -verson less then 3.10 or not install install pythin with apt
# sudo apt install python3 python3-pip # Optional

pip install --upgrade pip

## Environments
- [Python venv](https://docs.python.org/3/tutorial/venv.html#)
- [Python in containers](https://hub.docker.com/_/python/)

### Create  PCEP Jyputer notebook virtual Environment

# for this setup you will be creating a python virtual environment under the github repo's home.  We are creating a venv environment for Jupyter-lab supporting PCEP examples.  

python -m venv <your-env-name>
## create environment.  This will create a folder with the same name (pcep-venv).
python -m venv pcep-venv
source pcep-venv/bin/activate
pip install jupyterlab 
pip list

# you can launch jupyter-lab from the github home or cd into PCEP directory
cd PCEP
# launch Jupyter lab
jupyter-lab --no-browser

## jupyter-lab command produces url.  Copy and paste into browser
    Or copy and paste one of these URLs:
        http://localhost:8888/lab?token=2191a5c9174a4a3a523942ecaf824fc930832aaf24ba5c2d
        http://127.0.0.1:8888/lab?token=2191a5c9174a4a3a523942ecaf824fc930832aaf24ba5c2d

# to deactivate run:  
# don't run unless want to deactivate env. Environment persists reboots
deactivate

## Jupyter lab with VIM key bindings
[Jupyter lab vim](https://pypi.org/project/jupyterlab-vim/#:~:text=Notebook%20cell%20vim%20bindings.%20Like%20vim,%20Jupyterlab%20has%20a%20distinction)
pip install --upgrade jupyterlab-vim >= 4.0.1

jupyter-lab --no-browser

## DOCKER alternative
docker run --rm -p 8889:8888 quay.io/jupyter/base-notebook start-notebook.py --NotebookApp.token='my-token'

Simple Windows Setup

### VIOLA

Voilà is a Python package that transforms Jupyter Notebooks into interactive web applications.  We aren't using, but we can investigate later