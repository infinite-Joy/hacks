# start a new vim

# to install in ubuntu
# if present platform is ubuntu then install
if python -mplatform | grep -qi Ubuntu; then
    sudo add-apt-repository ppa:pi-rho/dev
    sudo apt-get update
    sudo apt-get install vim-gtk3 
fi


# get vimrc
wget https://raw.githubusercontent.com/infinite-Joy/hacks/master/my_vimrc
mv my_vimrc ~/.vimrc

# vundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# install python-mode
cd ~/.vim
mkdir -p bundle && cd bundle
git clone https://github.com/klen/python-mode.git

vim +PluginInstall +qall

# in case you are interested in clojure development do the following
cd ~/.vim/bundle
git clone git://github.com/tpope/vim-fireplace.git

