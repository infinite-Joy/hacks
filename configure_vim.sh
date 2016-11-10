# start a new vim

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
