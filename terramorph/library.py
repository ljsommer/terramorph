#!/usr/bin/python

import logger
from os import listdir, symlink, remove
from os.path import abspath, exists, getmtime, isfile, join, makedirs
import shutil

'''
Check environment out of library:
Create symlinks to all files in env directory
'''
def checkout(code_dir, env_name):
    log = logger.create_logger()
    env_dir = join(code_dir, 'env', env_name)
    log.debug("Env_dir: %s", env_dir)

    symlink_targets = [f for f in listdir(env_dir) if isfile(join(env_dir, f))]
    log.debug("Files to be symlinked: %s", symlink_targets)

    for file in symlink_targets:
        file_path = join(file, env_dir)
        src = abspath(file_path)
        dst = join(code_dir, file)
        symlink(src, dst)
        log.debug("Symlink created: %s -> %s", src, dst)

    return symlink_targets

'''
Once execution is complete, sanitize the workspace by removing symlinks
and checking the .terraform directory back into the environment library
'''
def cleanup(code_dir, env_name, symlinks):
    log = logger.create_logger()
    log.debug("Cleanup: Removing symlinks: %s", symlinks)
    for file in symlinks:
        remove(file)

    terraform_dir = join(code_dir, ".terraform/")
    if terraform_dir.is_dir():
        log.debug(
            "Cleanup: Sanitizing working directory by deleting .terraform directory"
        )
        shutil.rmtree(terraform_dir)

'''
The orphanage is for archiving away .terraform directories that are not
managed by Terramorph. With remote state configurations these directories
contain only terraform.tfstate files so as long as that file is excluded
in .gitignore these won't show up in commits
'''
def orphanage(code_dir):
    log = logger.create_logger()
    orphanage_dir = join(code_dir, '.tm_orphanage')
    orphan_tf_dir = join(code_dir, ".terraform/")
    orphan_tf_dir_timestamped = getmtime(orphan_tf_dir)

    if orphan_tf_dir.is_dir():
        log.warn("A .terraform directory was found that is not managed by Terramorph.")
        log.warn("Moving and renaming .terraform to: %s", orphan_tf_dir_timestamped)
        if not exists(orphanage_dir):
            makedirs(orphanage_dir)
        shutil.copytree(orphan_tf_dir, orphanage_dir)
