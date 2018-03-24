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

    env = environment.name()
    argument = environment.validate_argument(sys.argv)

    #library.setup()
    terraform.execute(argument, env)
    
main()
