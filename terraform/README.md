# Example

This directory is an example of a "layer" or "segment" of Terraform code. 
If you imagine a traditional three tier web design as:

* Load balancer
* Web servers
* Database

then each of these would be a layer. We could further summarize the layers as "Network", "Application", and "Database".
This same design applies in AWS as well, but often the "Network" layer involves other pieces necessary to a private cloud design:

* Network (layer)
    * VPC (segment)
        * Subnets
        * NACLs
        * Internet Gateway
        * NAT Gateway
    * Proxy servers (segment)
* Application (layer)
    * Application server for app "Foo" (segment)
    * Application lambdas for app "Bar" (segment)
* Database (layer) 
    * Database/caching for app "Foo" (segment)
    * Database/caching for app "Bar" (segment)

In this design, each nested bullet point (the segments) are self-contained Terraform codebases that build on one another.
For example, the VPC segment in the Network layer depends on nothing, but the Proxy server segment in the Network layer depends on the VPC segment. This extends to the Application and Database layers and all segments.

In other words, there is an 'order of execution' that needs to be considered.

On top of this, you have environments to consider, which will have not only different variables like CIDR blocks, hostnames, etc but also different AWS accounts if you have account segmentation.

## Benefits

With this design we have a limited blast radius for accidental runs which increases safety and confidence when working with complex and distributed cloud architectures. This moves us closer to truly having 'infrastructure as code' which can be automated with a CI/CD pipeline.
