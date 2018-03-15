terraform {
 required_version = ">= 0.11.0"

 backend "s3" {
   bucket         = "terraform-state-684159216331"
   encrypt        = "true"
   key            = "us-west2/dev/terramorph/network/vpc/terraform.tfstate"
   profile        = "ljsommer_windows"
   region         = "us-west2"
 }
}