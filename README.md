# terramorph

![terramorph](https://github.com/ljsommer/terramorph/blob/master/terramorph.png?raw=true)

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

Abstraction tooling built in Docker for Terraform.

The name of this tool is obviously pulled from Terraform, but I needed a spin on the name and thought of one of my favorite games, Final Fantasy 6 (3) and the character Terra, who has the ability to morph into a creature thus gaining new powers.

## Best-practice directory structure
In the ./terraform/ folder you'll see an example of a directory structure layout for a layer (segment) of Terraform code. There is an env directory which contains an environment named 'dev'. The files in dev get symlinked into the working directory for code execution and then unsymlinked when code execution is complete.

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