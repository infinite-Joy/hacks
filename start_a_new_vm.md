# documentation on after creating a new vm

## install gcc g++
sudo apt-get install build-essential

# how to install python3
http://askubuntu.com/questions/244544/how-do-i-install-python-3-3/290283#290283

sudo apt-get install python-software-properties
sudo add-apt-repository ppa:fkrull/deadsnakes
sudo apt-get update
sudo apt-get install python3.3

# how to install anaconda

wget http://repo.continuum.io/archive/Anaconda3-4.0.0-Linux-x86.sh

sudo bash Anaconda3-4.0.0-Linux-x86.sh

# install git 

sudo apt-get install git-core

git config --global user.name "Joydeep Bhattacharjee"
git config --global user.email joydeepubuntu@gmail.com

# see if pip is installed else

sudo apt-get install python3-setuptools
sudo easy_install3 pip

# create virtual env through conda will 

conda create --name py3_venv_deepL_conda python

-- To activate this environment, use:
-- $ source activate py3_venv_deepL_conda

-- To deactivate this environment, use:
-- $ source deactivate


# use this for  conda
http://kylepurdon.com/blog/using-continuum-analytics-conda-as-a-replacement-for-virtualenv-pyenv-and-more.html

# to install theano

sudo pip install git+git://github.com/Theano/Theano.git --upgrade --no-deps

https://github.com/yerv000/how_to-gvim_from_source




vim --version

# add python vim

wget http://www.vim.org/scripts/download_script.php?src_id=21056
mkdir ~/.vim/syntax
mv download_script.php\?src_id\=21056 ~/.vim/syntax/python.vim

# add haskell vim
follow this document
https://github.com/raichoo/haskell-vim

## install all the plugins

vim +PluginInstall +qall
