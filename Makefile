all:
	cp	-Rpv	\
	.bash_completion.d	\
	.bash_profile	\
	.gitconfig	\
	.gitignore_global	\
	.htoprc	\
	.nanorc	\
	.ncftp	\
	.rackspace-rc	\
	.screenrc	\
	.vim	\
	.vimrc	\
	.wgetrc	~/

	[ -f ~/.ssh/config ]	||	cp -Rpv .ssh ~/
	[ -f ~/.my.cnf ]		||	cp -Rpv .my.cnf ~/

.PHONY: all
