#!/usr/bin/python
"""
Terraform functionality wrapper utility
"""
import os
import library
import logger

def main():
    """Main entry point"""
    log = logger.create_logger()

    def str_to_bool(string):
        """Convert string to boolean"""
        return bool(string == 'True')

    library.setup()

    

main()
