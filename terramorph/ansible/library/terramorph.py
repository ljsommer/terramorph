#!/usr/bin/python

DOCUMENTATION = '''
---
module: terramorph
short_description: Build a layered Terraform codebase using Terramorph
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


def init():
    pass

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
        "plan_only": {"default": False, "type": "bool"},
        "apply_confirm": {"default": True, "type": "bool"},
        "destroy_force": {"default": False, "type": "bool"}
    }

    choice_map = {
        "present": create,
        "absent": destroy,
    }

    module = AnsibleModule(argument_spec=fields)
    is_error, has_changed, result = choice_map.get(
        module.params['state'])(module.params)

    if not is_error:
        module.exit_json(changed=has_changed, meta=result)
    else:
        module.fail_json(msg="Error deleting repo", meta=result)

if __name__ == '__main__':
    main()