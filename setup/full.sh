#! /bin/bash

alpine_version="3.7"
ansible_version="2.5.0"
image_name="terramorph"
terraform_version="0.11.3"

echo ""
echo "Building Docker image: $image_name with Ansible and Terraform"
echo "   Ansible version: $ansible_version"
echo "   Terraform version: $terraform_version"
echo ""

docker build -t $image_name \
    --build-arg alpine_version=$alpine_version \
    --build-arg ansible_version=$ansible_version \
    --build-arg terraform_version=$terraform_version \
    ..

function terramorph () {
    if [[ -z "${TM_ENV}" ]]; then
        echo "TM_ENV environment variable not set. Please set and re-run."
        return 1
    else
        printf "TM_ENV (environment for Terramorph execution) recognized as ${TM_ENV}\n"
    fi

    if [[ -z "${TM_LOG_LEVEL}" ]]; then
        echo "TM_LOG_LEVEL environment variable not set. Using default 'info'."
        return 1
    else
        printf "TM_LOG_LEVEL (log level output for Terramorph) recognized as ${TM_LOG_LEVEL}\n\n"
    fi

    if [ $# -eq 0 ] ; then
        tm_argument="help"
    else
        tm_argument=$1
    fi

    # If AWS_* creds are set, export to ~/.aws/terramorph, to import in the container
    if [[ -v AWS_ACCESS_KEY_ID ]] && [[ -v AWS_SECRET_ACCESS_KEY ]]; then
        mkdir ${HOME}/.aws &>/dev/null && touch ${HOME}/.aws/terramorph &>/dev/null
        echo export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID >> ${HOME}/.aws/terramorph
        echo export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY >> ${HOME}/.aws/terramorph
        if [[ -v AWS_SESSION_TOKEN ]]; then echo export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN >> ${HOME}/.aws/terramorph; fi
    fi 
    
    docker run -i -t --rm \
        -e "TM_LOG_LEVEL=$TM_LOG_LEVEL" \
        -e "TM_ENV=$TM_ENV" \
        -v ${HOME}/.aws/:/root/.aws/ \
        -v ${HOME}/.ssh/:/root/.ssh/ \
        -v $(pwd):/opt/terramorph/code/ \
        terramorph $tm_argument
}

if [[ ! -s "$HOME/.bash_profile" && -s "$HOME/.profile" ]] ; then
    profile_file="$HOME/.profile"
else
    profile_file="$HOME/.bash_profile"
fi

terramorph_function_file="$HOME/.terramorph.sh"

# If the Terramorph function file exists, delete it before recreating it
[ -e $terramorph_function_file ] && rm $terramorph_function_file
echo "function $(declare -f terramorph)"  >> "${terramorph_function_file}"
echo "alias tm=terramorph" >> "${terramorph_function_file}"

# Configure profile to load the terramorph function file 
if ! grep -q 'terramorph' "${profile_file}" ; then
    echo "Editing ${profile_file} to configure Terramorph function on terminal launch"
    echo "" >> "${profile_file}"
    echo "###" >> "${profile_file}"
    echo "# Terramorph" >> "${profile_file}"
    echo "###" >> "${profile_file}"
    echo "source ${terramorph_function_file}" >> "${profile_file}"
    echo "echo \"Loaded ${terramorph_function_file}\"" >> "${profile_file}"
fi

source $terramorph_function_file
