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

The design of this tool builds on the concept of layering, segmentation, and remote states to create working environments in each code context. If you don't have this directory structure in place in your projects, then this won't do you much good.
Modules, while highly recommended, are not necessary for this tool to function.

[Note: I intend to make a YouTube video with whiteboard diagrams to explain this concept, but for now this will have to do]
* Segment: A directory containing Terraform code that may or may not refer to remote state from another segment
* Layer: A logical grouping of code context directories that compromise a piece of your environment (think: three tier web architecture)
* Libary: An environment directory inside a segment which contains relevant configuration files for an environment


## Development
* Currently the logging level (to the python) is being passed in the full.* files. This is not ideal, but I don't want to spend a lot of time on that right now.

* Windows ENV's are frustrating and time consuming, so for the time being I am handling a lot in the .ps1 file.