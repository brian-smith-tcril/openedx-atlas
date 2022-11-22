help: ## display this help message
	@echo "Please use \`make <target>' where <target> is one of"
	@awk -F ':.*?## ' '/^[a-zA-Z]/ && NF==2 {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

builddir:
	mkdir -p build

copyconfig: builddir
	cp atlas.yml build/atlas.yml

# requires argbash to be installed
# installing argbash locally: https://argbash.readthedocs.io/en/stable/install.html#user-install
argbash: copyconfig ## generate atlas.sh from argbash template
	argbash -c atlas.argbash -o build/atlas.sh

# requires shellcheck to be installed
# installing shellcheck locally: https://github.com/koalaman/shellcheck#installing
shellcheck:
	shellcheck atlas.sh