all: gengetoptions

help: ## display this help message
	@echo "Please use \`make <target>' where <target> is one of"
	@awk -F ':.*?## ' '/^[a-zA-Z]/ && NF==2 {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort	

# requires getoptions to be installed
# installing getoptions locally: https://github.com/ko1nksm/getoptions/#installation
gengetoptions: ## use getoptions to generate argument parsing
	gengetoptions embed --overwrite atlas

# requires shellspec to be installed
# installing shellspec locally: https://github.com/shellspec/shellspec/#installation
# note: the linux CI uses version 0.28.1 installed by running: `curl -fsSL https://git.io/shellspec | sh -s 0.28.1 --yes`
#       the mac CI uses the latest stable version available in brew: `brew tap shellspec/shellspec`, `brew install shellspec`
test: ## automated testing using shellspec
	shellspec
