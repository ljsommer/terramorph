module "test_sqs" {
  source = "terraform-aws-modules/sqs/aws"

  name = "test"

  tags = {
    Environment = "dev"
  }
}
