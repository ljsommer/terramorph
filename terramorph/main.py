#!/usr/bin/python
"""
Terraform functionality wrapper utility
"""
import environment
import library
import logger
import os
import sys
import terraform


def main():
    log = logger.create_logger()
    log.info("Terramorph: Begin execution")

    argument = environment.validate_argument(sys.argv)
    code_dir = '/opt/terramorph/code/'
    env = environment.name()

    try:
        if not argument == "help":
            library.orphanage(code_dir)
            library.checkout_environment(code_dir, env)
            symlinks = library.checkout_symlinks(code_dir, env)
        terraform.execute(argument, env)
    finally:
        if not argument == "help":
            library.cleanup(code_dir, env, symlinks)

    log.info("Terramorph: End execution")
    
main()
