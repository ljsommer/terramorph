$terraform_version="0.11.3"

$container_aws_dir="/root/.aws"
$container_ssh_dir="/root/.ssh"

$local_aws_dir="$home\.aws"
$local_ssh_dir="$home\.ssh"

$container_name="terramorph"
$image_name="terramorph"

echo "Building Docker image: $image_name with Terraform version: ${terraform_version}"
#docker build -t $image_name --build-arg terraform_version=$terraform_version ./docker

$terramorph_function="Function Run-Terramorph `
{ `
    if (-not (Test-Path env:tm_log_level)) { `
        Write-Ouput `"Setting env`" `
        [Environment]::SetEnvironmentVariable(`"tm_log_level`", `"info`") `
    } `
    env_log_level=$env:tm_log_level `
    docker run -i -t --rm `
        --name $image_name `
        -v `"$local_aws_dir`:$container_aws_dir`" `
        -v `"$local_ssh_dir`:$container_ssh_dir`" `
        -e `"log_level=$env_log_level`" `
        $image_name `
}"

Write-Host $terramorph_function
# Ensure WindowsPowershell profile directory is present
# https://blogs.technet.microsoft.com/heyscriptingguy/2012/05/21/understanding-the-six-powershell-profiles/
New-Item -ItemType Directory -Force -Path $ps_profile_dir | Out-Null
$ps_profile_dir="$home\Documents\WindowsPowershell"

$alias='Set-Alias -Name terramorph -Value Run-Terramorph -Description "Launches Terramorph container"'
$alias_short='Set-Alias -Name tm -Value Run-Terramorph -Description "Launches Terramorph container (short-name)"'

if (!(Test-Path $ps_profile_dir\profile.ps1))
{
   New-Item -path $ps_profile_dir -name profile.ps1 -type "file" -value "$terramorph_function`n`n$alias`n$alias_short" | Out-Null
   Write-Host "Created Powershell profile and added aliases: $ps_profile_dir\profile.ps1"
}
else
{
    if (!(Get-Content $ps_profile_dir\profile.ps1 | Select-String Run-Terramorph))
    {
        Add-Content -path $ps_profile_dir\profile.ps1 -value "$terramorph_function`n`n$alias`n$alias_short"
        Write-Host "Added alias to existing Powershell profile: $ps_profile_dir\profile.ps1"
    }
}

Write-Host "Doing thing"

Invoke-Expression $terramorph_function
Invoke-Expression $alias
Invoke-Expression $alias_short