#!/usr/bin/python

import logger
from os import listdir
from os.path import isfile, join

def checkout(environment):
    log = logger.create_logger()
    
    files = [f for f in listdir(environment) if isfile(join(environment, f))]
    

