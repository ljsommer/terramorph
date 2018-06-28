#!/bin/sh

ansible="/usr/bin/ansible-playbook"
python="/usr/bin/python"
terramorph="/app/src/terramorph/terramorph.py"
working_dir="/opt/terramorph/code"

if [ -f /root/.aws/terramorph ]; then source /root/.aws/terramorph; rm /root/.aws/terramorph; fi

echo "Docker entrypoint file: Input read as $1"

cd ${working_dir}
if [ ${1: -4} == ".yml" ]; then
    # Convert backslashes to forward slashes, from Windows tab complete
    converted="${1//\\//}"
    echo "Docker entrypoint file: Executing ${ansible} ${converted}"
    echo ""
    ${ansible} ${converted}
else
    echo "Docker entrypoint file: Executing${python} ${terramorph} ${1}"
    echo ""
    ${python} ${terramorph} ${1}
fi 
