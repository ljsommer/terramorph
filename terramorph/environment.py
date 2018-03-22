#!/usr/bin/python

import logger
import os
import sys

log = logger.create_logger()

def name():
    return environment_name

def validate_input():
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

    if len(sys.argv) > 1:
        log.warn(
            "Terramorph does not currently support complex (more than one) arguments."
        )
        log.warn("Please select one of the following arguments: %s", supported_args)

    argument = sys.argv[0]

    if argument not in supported_args:
        log.warn("Argument: %s not supported at this time.", argument)
        log.warn("Supported arguments: %s", supported_args)

    return validated_input

