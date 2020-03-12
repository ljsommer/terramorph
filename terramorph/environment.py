#!/usr/bin/python
import logger
import os
import sys


def name():
    log = logger.create_logger()
    # Read directory structure here
    env = os.environ['TM_ENV']
    log.debug("Environment read from TM_ENV variable as %s", env)
    return env

def validate_arguments(argv):
    log = logger.create_logger()

    '''
    Pulled from: https://www.terraform.io/docs/commands/index.html
    '''
    supported_args = [
        'apply', 'destroy', 'help', 'fmt', 'init', 'plan', 'version'
    ]

    # Not yet used but wanna keep it around
    '''
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
    '''

    code_dir = '/opt/terramorph/code/'
    flag = ""

    if len(argv) == 2:
        argument = argv[1]

        if argument not in supported_args:
            log.warn("Argument: %s not supported at this time.", argument)
            log.warn("Supported arguments: %s", supported_args)
            sys.exit(1)
        
    elif len(argv) > 2:
        arguments = argv
        arguments.pop(0) # Remove the filename from the argv items
        log.debug("Arguments: %s", arguments)

        structure = {}

        for arg in arguments:
            if arg in supported_args:
                structure['command'] = arg
                argument = structure['command']
            elif arg.startswith("-"):
                log.debug("Terraform flag recognized: %s", arg)
                structure['tf_argument'] = arg
                flag = structure['tf_argument']
            elif os.path.isdir(os.path.join(code_dir, arg)):
                structure['directory'] = os.path.join(code_dir, arg)
            else:
                log.warn("An argument was found that is not able to be handled: %s", arg)
                sys.exit(1)
        
        code_dir = structure['directory']

        # This is a commented line to demonstrate version control for my cousin

    log.debug("Argument: %s", argument)
    if flag:
        log.debug("Terraform flag: %s", flag)
    log.debug("Code directory: %s", code_dir)
    return argument, flag, code_dir