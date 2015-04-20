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
	[ -f ~/.aws/config ]	||	cp -Rpv .aws ~/
	[ -f ~/.boto ]			||	cp -Rpv .boto ~/
	[ -f ~/.glacier.cfg ]	||	cp -Rpv .glacier.cfg ~/
	[ -f ~/.my.cnf ]		||	cp -Rpv .my.cnf ~/

.PHONY: all
