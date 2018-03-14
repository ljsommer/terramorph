import logging
import os
import sys


def create_logger():
    logging.getLogger('boto3').setLevel(logging.CRITICAL)
    logging.getLogger('botocore').setLevel(logging.CRITICAL)

    log_level = os.environ['log_level']
    numeric_level = getattr(logging, log_level.upper(), None)

    if not isinstance(numeric_level, int):
        raise ValueError('Invalid log level: %s', log_level)

    logging.basicConfig(
        stream=sys.stdout,
        format='%(asctime)s %(levelname)s: %(message)s',
        level=numeric_level
    )

    logger = logging.getLogger()

    return logger
