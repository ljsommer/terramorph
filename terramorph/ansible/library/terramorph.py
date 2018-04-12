#!/usr/bin/python

import subprocess
import sys

DOCUMENTATION = '''
---
module: terramorph
short_description: Build a layered Terraform codebase using Terramorph. 
"directory" attribute is relative to playbook file location.
Note that I do not track state change for idempotence because this is an abstraction layer and state changes are tracked
    in Terraform. I have no plans to add that functionality into the Ansible module at this time.
'''

EXAMPLES = '''
- name: Execute a 'terraform plan' for product foo VPC deployment
  terramorph:
    directory: "network/vpc"
    plan_only: True

- name: Deploy product foo VPC and auto-confirm the prompt for creation
  terramorph:
    apply_confirm: True # This will not prompt you to accept the proposed changes
    directory: "network/vpc"

- name: Destroy product foo application deployment
  terramorph:
    destroy_force: True # This will destroy the resources without prompting you
    directory: "application/foo"
    state: absent
  register: result
'''

from ansible.module_utils.basic import *
from ansible.module_utils.terramorph import *
from ansible.module_utils.environment import *
from ansible.module_utils.library import *
from ansible.module_utils.logger import *
from ansible.module_utils.terraform import *

#PYTHON = "/usr/bin/python"
#TM = "/app/src/terramorph/main.py"

def init(data):
    argument = "init"
    directory = data['directory']

    #subprocess.call([PYTHON, TM, directory, "init"], stdout=subprocess.PIPE)
    terramorph.main(argument, directory)

    '''
    child = subprocess.Popen([PYTHON, TM, "init"], cwd= directory, stdout=subprocess.PIPE)
    streamdata = child.communicate()[0]
    rc = child.returncode
    '''

    #meta = {"status": rc, 'response': streamdata}
    '''
    if rc == 0:
        return False, streamdata
    if rc == 1:
        return True, streamdata
    '''
    #return streamdata

def plan():
    pass

def apply():
    pass

def destroy():
    pass

def create():
    pass

def main():
    fields = {
        "apply_confirm": {"default": True, "type": "bool"},
        "destroy_force": {"default": False, "type": "bool"},
        "directory": {"required": True, "type": "str"},
        "plan_only": {"default": False, "type": "bool"},
        "state": {
        	"default": "present", 
        	"choices": ['present', 'absent'],  
        	"type": 'str' 
        }
    }

    choice_map = {
        "present": init,
        "absent": destroy
    }

    module = AnsibleModule(argument_spec=fields)
    result = choice_map.get(module.params['state'])(module.params)

    #if not is_error:
    module.exit_json(msg="Successfully executed Terraform command.", meta=result)
    '''
    else:
        module.fail_json(msg="Error executing Terraform command.", meta=result)
    '''

if __name__ == '__main__':
    main()