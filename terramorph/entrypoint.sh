#!/bin/sh

ansible="/usr/bin/ansible-playbook"
python="/usr/bin/python"
terramorph="/app/src/terramorph/terramorph.py"
working_dir="/opt/terramorph/code"

echo "Entrypoint file: Input read as $1"

cd ${working_dir}
if [ ${1: -4} == ".yml" ]; then
    ${ansible} ${1}
else
    ${python} ${terramorph} ${1}
fi 
