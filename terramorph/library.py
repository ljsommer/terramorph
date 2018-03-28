#!/usr/bin/python

from . import logger
from os import listdir, makedirs, symlink, remove, rename
from os.path import abspath, exists, isdir, islink, getmtime, isfile, join
import shutil
import sys
import time

'''
Check environment out of library:
    Move .terraform library directory into working directory:
        * terraform.tfstate file 
        * downloaded modules
        * downloaded plugins
'''
def checkout_environment(code_dir, env_name):
    log = logger.create_logger()
    env_dir = join(code_dir, 'env', env_name)
    log.debug("Env_dir: %s", env_dir)

    # Library directory
    terraform_dir = join(code_dir, '.terraform/')
    terramorph_dir = join(code_dir, '.terramorph/')
    terramorph_env_dir = join(terramorph_dir, 'environments')
    existing_library_dir = join(terramorph_env_dir, env_name)

    if isdir(existing_library_dir):
        log.info("Existing libary directory found for environment: %s", env_name)
        log.info("Moving %s into %s for execution", existing_library_dir, terraform_dir)

        shutil.copytree(existing_library_dir, terraform_dir)
        shutil.rmtree(existing_library_dir)

'''
Check symlinks out of library:
    Create symlinks to all files in env directory
'''
def checkout_symlinks(code_dir, env_name):
    log = logger.create_logger()
    env_dir = join(code_dir, 'env', env_name)
    log.debug("Env_dir: %s", env_dir)

    symlink_targets = [f for f in listdir(env_dir) if isfile(join(env_dir, f))]
    log.debug("Files to be symlinked: %s", symlink_targets)
    symlinks = []

    for file in symlink_targets:
        file_path = join(env_dir, file)
        src = abspath(file_path)
        dst = join(code_dir, file)

        if islink(dst):
            remove(dst)
        elif isfile(dst):
            file_bak = file + '.bak'
            backup = join(code_dir, file_bak)
            log.warn(
                "A file already exists: %s - renaming to %s as a backup",
                dst, backup
            )
            rename(dst, backup)

        symlink(src, dst)
        log.debug("Symlink created: %s -> %s", src, dst)
        symlinks.append(dst)

    return symlinks

'''
Once execution is complete, sanitize the workspace by removing symlinks
and checking the .terraform directory back into the environment library
'''
def cleanup(code_dir, env_name, symlinks):
    log = logger.create_logger()
    log.debug("Cleanup: Removing symlinks: %s", symlinks)

    for file in symlinks:
        if islink(file):
            try:
                remove(file)
            except OSError:
                pass
        else:
            log.warn("File %s is not a symlink, please investigate.", file)

    terraform_dir = join(code_dir, '.terraform/')
    terramorph_dir = join(code_dir, '.terramorph/')
    terramorph_env_dir = join(terramorph_dir, 'environments')
    existing_library_dir = join(terramorph_env_dir, env_name)

    if isdir(terraform_dir):
        log.debug(
            "Cleanup: Sanitizing working directory by checking .terraform/ back into library"
        )
        log.debug(
            "Moving %s to %s", terraform_dir, existing_library_dir
        )
        shutil.copytree(terraform_dir, existing_library_dir)
        shutil.rmtree(terraform_dir)

'''
The orphanage is for archiving away .terraform directories that are not
managed by Terramorph
'''
def orphanage(code_dir):
    log = logger.create_logger()
    orphanage_dir = join(code_dir, '.terramorph/', 'orphanage/')
    orphan_tf_dir = join(code_dir, ".terraform/")

    if isdir(orphan_tf_dir):
        # Get last modified time of .terraform/ directory for name
        orphan_tf_dir_timestamped = time.strftime(
            '%m-%d-%Y-%T', time.gmtime(getmtime(orphan_tf_dir))
        )
        orphan_dir_name = 'terraform-' + orphan_tf_dir_timestamped
        orphan_dest_path = join(orphanage_dir, orphan_dir_name)

        log.warn("A .terraform directory was found that is not managed by Terramorph.")
        log.warn("Moving and renaming .terraform/ to: %s", orphan_dest_path)
        if not exists(orphanage_dir):
            makedirs(orphanage_dir)
        shutil.copytree(orphan_tf_dir, orphan_dest_path)
        shutil.rmtree(orphan_tf_dir)
