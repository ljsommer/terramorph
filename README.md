# terramorph

![alt text](https://raw.githubusercontent.com/ljsommer/terramorph/terramorph.png)

Abstraction tooling built in Docker for Terraform.

The name of this tool is obviously pulled from Terraform, but I needed a spin on the name and thought of one of my favorite games, Final Fantasy 6 (3) and the character Terra, who has the ability to morph into a creature thus gaining new powers.

The design of this tool builds on the concept of layering, segmentation, and remote states to create working environments in each code context. If you don't have this directory structure in place in your projects, then this won't do you much good.
Modules, while highly recommended, are not necessary for this tool to function.

[Note: I intend to make a YouTube video with whiteboard diagrams to explain this concept, but for now this will have to do]
* Segment: A directory containing Terraform code that may or may not refer to remote state from another segment
* Layer: A logical grouping of code context directories that compromise a piece of your environment (think: three tier web architecture)
* Libary: An environment directory inside a segment which contains relevant configuration files for an environment


