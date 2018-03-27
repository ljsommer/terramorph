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
    """Main entry point"""
    log = logger.create_logger()
    log.debug("Terramorph: Begin execution")

    code_dir = '/opt/terramorph/code/'

    env = environment.name()
    argument = environment.validate_argument(sys.argv)

    library.orphanage(code_dir)
    symlinks = library.checkout(code_dir, env)
    terraform.execute(argument, env)
    library.cleanup(code_dir, env, symlinks)

    log.debug("Terramorph: End execution")
    
main()
