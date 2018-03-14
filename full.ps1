Param([string]$loglevel="info")

echo "Log level set as $loglevel"

$terraform_version="0.11.3"

$aws_default_region="us-west-2"

$container_aws_dir="/root/.aws"
$container_ssh_dir="/root/.ssh"

$local_aws_dir="$home\.aws"
$local_ssh_dir="$home\.ssh"

$container_name="terramorph"
$image_name="terramorph"

echo "Building Docker image: $image_name with Terraform version: ${terraform_version}"
docker build -t $image_name --build-arg terraform_version=$terraform_version ./docker

docker run -i -t --rm `
    --name $image_name `
    -v "$local_aws_dir`:$container_aws_dir" `
    -v "$local_ssh_dir`:$container_ssh_dir" `
    -e "AWS_DEFAULT_REGION=$aws_default_region" `
    -e "log_level=$loglevel" `
    $image_name