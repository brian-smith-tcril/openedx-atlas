#!/bin/bash

set -eu

# @getoptions
parser_definition() {
	setup       REST help:usage -- \
				"Atlas is a CLI tool that has essentially one command: \`atlas pull\`\n \nAtlas defaults to using a configuration file named \`atlas.yml\` placed\nin the root directory. Configuration file:\n \npull:\n  branch: <branch-name>\n  directory <directory-name>\n  repository: <organization-name>/<repository-name>\n \nAtlas can also use a configuration file in a different path using the \`--config\` flag\nafter \`atlas\`: \`atlas --config pull\`.\n \nAtlas can also be used without a configuration file by using the flags below after\n\`atlas pull\`.\n \n\`-b\` or \`--branch\`\n\`-r\` or \`--repository\`\n\`-d\` or \`--directory\`\n" ''
	msg 	 -- '' 'Commands:'
	cmd pull -- "pull"
}

parser_definition_pull() {
	setup   REST help:usage -- \
		"Usage: ${2##*/} pull [options...] [arguments...]"
	msg -- 'Options:'
	config      PARAM      --config				-- "path to alternative atlas.yaml configuration file"
	branch      PARAM   -b --branch				-- "A branch of translation files"
	repository  PARAM   -r --repository			-- "The repository containing translation files"
	directory	PARAM	-d --directory			-- "Directory (name of the repository) containing translations to be downloaded"
	disp    :usage  -h --help	
}
# @end

parse_yaml() {
    # adapted from https://gist.github.com/pkuczynski/8665367
    local prefix=$2
    local s='[[:space:]]*' w='[a-zA-Z0-9_]*'
    local fs
    fs=$(echo @|tr @ '\034')
    sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  "$1" |
    awk -F"$fs" '{
        indent = length($1)/2;
        vname[indent] = $2;
        for (i in vname) {if (i > indent) {delete vname[i]}}
        if (length($3) > 0) {
            vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
            printf("%s%s%s=\"%s\"\n", "'"$prefix"'",vn, $2, $3);
        }
    }'
}

# only do stuff if the positional arg is "pull"
# for some reason shellcheck doesn't see this var as being set anywhere...
# shellcheck disable=SC2154
if [ "$_arg_positional_command_arg" == "pull" ]; # Download the translation files from a repository branch.
then
    # Set vars from config yaml
    if [ "$_arg_config" ];
    then
        eval "$(parse_yaml "$_arg_config")"
    else
        eval "$(parse_yaml atlas.yml)"
    fi

    # Override vars based on args
    if [ "$_arg_directory" ];
    then
        pull_directory=$_arg_directory
    fi
    
    if [ "$_arg_repository" ];
    then
        pull_repository=$_arg_repository
    fi

    if [ "$_arg_branch" ];
    then
        pull_branch=$_arg_branch
    fi

    # Output configured vars to user
    echo "Pulling translation files"
    echo " - directory: $pull_directory"
    echo " - repository: $pull_repository"
    echo " - branch: $pull_branch"

    # Create temp dir for translations
    mkdir translations_TEMP
    cd translations_TEMP || exit

    # Initialize git repo and add remote
    git init -b main
    remote_url="https://github.com/$pull_repository.git"
    git remote add -f origin "$remote_url"

    # If a directory is specified, configure git for a sparse checkout
    if [ "$pull_directory" ];
    then
        git config core.sparseCheckout true
        git sparse-checkout init
        git sparse-checkout set "$pull_directory"
    fi

    # Retrieve translation files from the repo
    git pull origin "$pull_branch"

    # Remove .git directory
    rm -rf .git

    # Leave the temp dir
    cd ..

    # Copy translation files out of the temp dir
    if [ "$pull_directory" ];
    then
        cp -r translations_TEMP/"$pull_directory"/* ./
    else
        cp -r translations_TEMP/* ./
    fi

    # Remove the temp dir
    rm -rf translations_TEMP
fi
