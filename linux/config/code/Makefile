#
# Manage code extensions
#

usage: 
	@echo "Usage: make list-extensions | install-extensions"

list-extensions:
	code --list-extensions > $(HOME)/work/github/setup-tools/linux/config/code/extensions.txt

install-extensions:
	cat $(HOME)/work/github/setup-tools/linux/config/code/extensions.txt | xargs -L 1 code --install-extension
