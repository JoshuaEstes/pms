# @see https://github.com/VundleVim/Vundle.vim/wiki/Tips-and-Tricks
if [ "$PMS_VUNDLE_AUTOUPDATE" -eq "1" ]; then
    vim -c VundleUpdate -c quitall
fi
