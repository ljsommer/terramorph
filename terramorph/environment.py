#!/usr/bin/python
import logger
import os
import sys


def name():
    log = logger.create_logger()
    # Read directory structure here
    env = "dev"
    return env

def validate_argument(argv):
    log = logger.create_logger()

    '''
    Pulled from: https://www.terraform.io/docs/commands/index.html
    '''
    supported_args = [
        'apply', 'destroy', 'fmt', 'init', 'plan', 'version'
    ]

    unsupported_args = [
        'console',
        'get',
        'graph',
        'import',
        'output',
        'providers',
        'push',
        'refresh',
        'show',
        'taint',
        'untaint',
        'validate',
        'workspace'
    ]

    if len(argv) == 2:
        argument = argv[1]

        if argument not in supported_args:
            log.warn("Argument: %s not supported at this time.", argument)
            log.warn("Supported arguments: %s", supported_args)
            sys.exit(1)
        
    elif len(argv) > 2:
        log.warn(
            "Terramorph does not currently support complex (more than one) arguments."
        )
        log.warn("Please select one of the following arguments: %s", supported_args)
        sys.exit(1)
    
    else:
        argument = ""

    return argument