provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.region}"
}

terraform {
 required_version = ">= 0.11.0"

 backend "s3" {
   bucket         = "terraform-state-684159216331"
   encrypt        = "true"
   key            = "us-west-2/dev/terramorph/application/test/terraform.tfstate"
   profile        = "ljsommer"
   region         = "us-west-2"
 }
}
