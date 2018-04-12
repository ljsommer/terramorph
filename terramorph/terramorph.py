#!/usr/bin/python
"""
Terraform functionality wrapper utility
"""
import os
import sys
sys.path.append(os.path.realpath(os.path.dirname(__file__)))

import environment
import library
import logger
import terraform

def main():
    log = logger.create_logger()
    log.info("Terramorph: Begin execution")

    env = environment.name()
    argument, flag, code_dir = environment.validate_arguments(sys.argv)

    try:
        if not argument == "help":
            library.orphanage(code_dir)
            symlinks = library.checkout_symlinks(code_dir, env)
            library.checkout_environment(code_dir, env)
        terraform.execute(argument, flag, code_dir, env)
    finally:
        if not argument == "help":
            library.cleanup(code_dir, env, symlinks)

    log.info("Terramorph: End execution")

main()
