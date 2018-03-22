#!/usr/bin/python
"""
Terraform functionality wrapper utility
"""
import os
import ec2
import library
import logger
import setup

def main():
    """Main entry point"""
    log = logger.create_logger()

    def str_to_bool(string):
        """Convert string to boolean"""
        return bool(string == 'True')

    library.setup()

    

main()
