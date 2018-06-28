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
    function config() {
        mkdir ${HOME}/.terramorph &>/dev/null && touch ${HOME}/.terramorph/config &>/dev/null
        read -p "Terramorph profile [default]: " TM_PROFILE
        read -p "Terramorph environment [dev]: " TM_ENV
        read -p "Terramorph log level [info]: " TM_LOG_LEVEL
        read -p "Terraform modules directory [/opt/terramorph/code]: " TM_MODULES

        if [[ -z "$TM_PROFILE" ]] ; then export TM_PROFILE=default; fi
        if [[ -z "$TM_ENV" ]] ; then export TM_ENV=dev; fi
        if [[ -z "$TM_LOG_LEVEL" ]] ; then export TM_LOG_LEVEL=info; fi
        if [[ -z "$TM_MODULES" ]]; then export TM_MODULES=/opt/terramorph/code; fi
    
        sed -i "" -e '/\['"$TM_PROFILE"'\]/{N;N;N;d;}' ${HOME}/.terramorph/config &>/dev/null
      
        echo ["$TM_PROFILE"] >> ~/.terramorph/config
        echo TM_ENV=$TM_ENV >> ~/.terramorph/config
        echo TM_LOG_LEVEL=$TM_LOG_LEVEL >> ~/.terramorph/config
        echo TM_MODULES=$TM_MODULES >> ~/.terramorph/config 

        echo "$TM_PROFILE"
    }

    if [[ "$1" = "config" ]] || [[ ! -s ${HOME}/.terramorph/config ]] ; then
      export TM_PROFILE=$(config)  
      return 0 
    fi

    if [[ -z "${TM_PROFILE}" ]]; then read -p "Set current Terramorph profile [default]: " TM_PROFILE; fi

    if [[ -z "${TM_PROFILE}" ]]; then export TM_PROFILE=default; fi

    if grep -qF "[${TM_PROFILE}]" ${HOME}/.terramorph/config; then
        export $(sed -n '/\['"${TM_PROFILE}"'\]/{n;p;n;p;n;p;}' ${HOME}/.terramorph/config)
        printf "TM_PROFILE (profile for Terramorph exection) recognized as ${TM_PROFILE}\n"
    else
        echo "TM_PROFILE: ${TM_PROFILE}, is not a valid profile in ${HOME}/.terramorph/config."
        echo "Please configure and re-run, or run 'tm config'."
        return 1 
    fi

    if [[ -z "${TM_ENV}" ]]; then
        echo "TM_ENV environment variable not set. Please set and re-run, or run 'tm config'."
        return 1
    else
        printf "TM_ENV (environment for Terramorph execution) recognized as ${TM_ENV}\n"
    fi

    if [[ -z "${TM_LOG_LEVEL}" ]]; then
        export TM_LOG_LEVEL=info 
        echo "TM_LOG_LEVEL environment variable not set. Using default 'info'."
    else
        printf "TM_LOG_LEVEL (log level output for Terramorph) recognized as ${TM_LOG_LEVEL}\n\n"
    fi

    if [[ -z "${TM_MODULES}" ]]; then
        echo "TM_MODULES environment variable not set. Please set and re-run, or run 'tm config'."
    elif [[ ! -d "${TM_MODULES}" ]]; then
        echo "TM_MODULES environment variable value: ${TM_MODULES} is not a directory."
        echo "Please set and re-run, or run 'tm config'."
    else
        printf "TM_MODULES (Module environment for Terramorph execution) recognized as ${TM_MODULES}\n\n"
    fi

    if [ $# -eq 0 ] ; then
        tm_argument="help"
    else
        tm_argument=$1
    fi
    
    docker run -i -t --rm \
        -e "TM_LOG_LEVEL=$TM_LOG_LEVEL" \
        -e "TM_ENV=$TM_ENV" \
        -v ${HOME}/.aws/:/root/.aws/ \
        -v ${HOME}/.ssh/:/root/.ssh/ \
        -v $(pwd):/opt/terramorph/code/ \
        -v $TM_MODULES:/opt/terramorph/modules \
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
