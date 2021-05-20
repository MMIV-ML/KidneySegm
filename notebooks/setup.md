# Setting up your system


## Anaconda:
We recommend installing Python via the [Anaconda Distribution](https://www.anaconda.com/download). Be sure to use the "Python 3.8" version or later. We will use the Conda Package Management System within the Anaconda Distribution. From the [documentation](https://conda.io/docs):
> Conda is an open source package management system and environment management system that runs on Windows, macOS and Linux. Conda quickly installs, runs and updates packages and their dependencies. Conda easily creates, saves, loads and switches between environments on your local computer.

After the installation run `python --version` in a terminal window (in "Anaconda Prompt" if you are using Windows). If the output show "Python 3.8" or later (and "Anaconda") you are good to go.

## GitHub:
The code is hosted on the code-sharing platform GitHub (where you now are reading this). If you do not have a GitHub account already you should make one now. We recommend that you are using the platform for you own projects .... https://github.com/join.

## Install and test the `kidney-segm` environment
 (see [here](environment.yml))

After you have successfully installed Anaconda, go through the following steps (if you are using Windows, be at the "Anaconda Prompt").

### Install Git:

```
conda install git
```
### Download the repository:

```
git clone https://github.com/MMIV-ML/KidneySegm.git
cd KidneySegm
```
### Configure the Python-environment:

```
conda env create -f environment.yml
```

### Activate the environment:

```
conda activate kidney-segm
```

### Install a Jupyter kernel:

```
python -m ipykernel install --user --name kidney-segm --display-name "KIDNEY-SEGM"
```


### Test your installation:
Go through the notebook `0_test-installation.ipynb` in the `test-notebooks`-directory:

```
cd test-notebooks
jupyter notebook
```
You can also use [JupyterLab](https://github.com/jupyterlab/jupyterlab): `jupyter lab`.

## Update:
The code and environment will be updated during the project. Run the following commands regularly from your local `KidneySegm` repository:
* Update code: `git pull`
* Update environment:

```
conda activate kidney-segm
conda env update
```
