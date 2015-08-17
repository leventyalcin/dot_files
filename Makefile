all:
	cp	-Rpv	\
	.bash_completion.d	\
	.bash_profile	\
	.gitconfig	\
	.gitignore_global	\
	.htoprc	\
	.nanorc	\
	.ncftp	\
	.screenrc	\
	.vim	\
	.vimrc	\
	.wgetrc	~/

	[ -f ~/.aws/config ]	||	cp -Rpv .aws ~/
	[ -f ~/.boto ]			||	cp -Rpv .boto ~/
	[ -f ~/.cli53 ]			||	cp -Rpv .cli53 ~/
	[ -f ~/.glacier.cfg ]	||	cp -Rpv .glacier.cfg ~/
	[ -f ~/.my.cnf ]		||	cp -Rpv .my.cnf ~/
	[ -f ~/.rackspace-rc ]	||	cp -Rpv .rackspace-rc ~/
	[ -f ~/.ssh/config ]	||	cp -Rpv .ssh ~/
	[ -d ~/.ssh/config.d ]  ||	mkdir ~/.ssh/config.d

.PHONY: all
