#!/usr/bin/python
"""
Terraform functionality wrapper utility
"""
from . import environment
from . import library
from . import logger
import os
import sys
import terraform


def main():
    """Main entry point"""
    log = logger.create_logger()
    log.info("Terramorph: Begin execution")

    code_dir = '/opt/terramorph/code/'

    env = environment.name()
    argument = environment.validate_argument(sys.argv)

    try:
        library.orphanage(code_dir)
        library.checkout_environment(code_dir, env)
        symlinks = library.checkout_symlinks(code_dir, env)
        terraform.execute(argument, env)
    finally:
        library.cleanup(code_dir, env, symlinks)

    log.info("Terramorph: End execution")
    
main()
