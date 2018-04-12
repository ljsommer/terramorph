#!/usr/bin/python
import logger
import os
from subprocess import call


def execute(argument, flag, code_dir, env):
    log = logger.create_logger()

    binary = "/opt/terramorph/terraform"
    if not argument:
        log.info("Executing %s (no argument passed) within the %s environment.", binary, env)
    else:
        log.info("Executing %s %s within the %s environment.", binary, argument, env)

    if not flag:
        call([binary, argument], cwd=code_dir)
    else:
        call([binary, argument, flag], cwd=code_dir)

