# terramorph

![terramorph](https://github.com/ljsommer/terramorph/blob/master/terramorph.png?raw=true)

Abstraction tooling built in Docker for Terraform.

The name of this tool is obviously pulled from Terraform, but I needed a spin on the name and thought of one of my favorite games, Final Fantasy 6 (3) and the character Terra, who has the ability to morph into a creature thus gaining new powers.


## YouTube
Problem statements and approach:
https://www.youtube.com/watch?v=HGOtliV_6K8&feature=youtu.be

Live demo:
https://www.youtube.com/watch?v=U3JPMpIVue8

##
Problem statement(s):
1. Developer/Build server Terraform version variance (Bob is on 0.9, Lisa is on 0.10 and the Build server is on 0.8)
2. Leveraging Terraform "layers" and "segments" in complex environments creates onerous bootstrap and teardown situations
3. Environment switching from dev -> lab -> perf -> (etc) can get messy with variables files, specifically the "terraform" code block which doesn't allow interpolation
  * https://www.terraform.io/docs/configuration/terraform.html#description
  * https://github.com/hashicorp/terraform/issues/13022
4. Terraform doens't work on all platforms (Windows)

## Usage
Windows:
*Note: Ensure your execution policy is configured to allow remote execution:*
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-6
```
. ./full.ps1
terramorph
tm
```

Linux/Mac:
```
source ./full.sh
terramorph
tm
```

### Demo
If you'd like to checkout how this may work in a multilayer Terraform codebase, you can try it out by following the steps below:
1. Install the tool following the steps above
  * Ensure Terramorph is working correctly by executing "tm" in a terminal window. If you're not seeing healthy output (AKA no errors) shoot me a message
2. Ensure your ~/.aws/credentials file has some valid profiles configured with AWS access keypairs with sufficient permissions
3. Ensure you have an S3 bucket setup that you can write to for Terraform state files (we'll use this in the next step)
4. cd into ./terraform/network/vpc/env/dev/ and configure the example files there by copying and renaming to remove the '.example'. Ensure all values are populated correctly.
5. cd into ./terraform/app/test/env/dev/ and configure the example files there by copying and renaming to remove the '.example'. Ensure all values are populated correctly.
6. cd back to the ./terraform/ root directory which contains the Ansible playbook to deploy your multi-layer environment
7. Execute the playbook by running "tm test-product.yml"
  * This will step into a pre-defined directory structure and execute Terramorph in each in a particular order. It will create all the resources and then tear down all the resources.

## Best-practice directory structure
In the ./terraform/ folder you'll see an example of a directory structure layout for a layer (segment) of Terraform code. There is an env directory which contains an environment named 'dev'. The files in dev get symlinked into the working directory for code execution and then unsymlinked when code execution is complete.

Visual example:
![terramorph](https://github.com/ljsommer/terramorph/blob/master/layers_segments.png?raw=true)

This has a few advantages:
* Clearly separate your environment variables
* Configure different environments to use different AWS Profiles in your ~/.aws/credentials files (and thus different accounts for different envs)
* Sanitize the working environment after each run so that you can move from env to env without fear of undesired effects (think: new code being deployed from dev to lab to staging to perf to prod etc)


[Note: I intend to make a YouTube video with whiteboard diagrams to explain this concept, but for now this will have to do]
* Segment: A directory containing Terraform code that may or may not refer to remote state from another segment
* Layer: A logical grouping of code context directories that compromise a piece of your environment (think: three tier web architecture)
* Libary: An environment directory inside a segment which contains relevant configuration files for an environment


## Development
* Windows: Currently the logging level (to the python) is being passed in the full.ps1. This is not ideal, but I don't want to spend a lot of time on that right now.
  * Side note: As of April 2018 I am a bit behind on Windows development so if you find a bug in the powershell setup stuff please let me know

## Notes
* The path to the playbook must be relative, not absolute. This is because the playbook is mounted into the container which will have a different directory setup