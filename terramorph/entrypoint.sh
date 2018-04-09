#!/bin/sh

ansible="/usr/bin/ansible"
python="/usr/bin/python"
terramorph="/app/src/terramorph/main.py"
working_dir="/opt/terramorph/code"

echo "Input read as $1"

if [ ${1: -4} == ".yml" ]; then
    ${ansible} ${1}
else
    cd ${working_dir}
    ${python} ${terramorph} ${1}
fi 