$container_aws_dir = "/root/.aws"
$container_name    = "terramorph"
$container_ssh_dir = "/root/.ssh"
$image_name        = "terramorph"
$local_aws_dir     = "$home\.aws"
$local_ssh_dir     = "$home\.ssh"
$log_level         = "debug"
$ps_module_dir  = "$home\Documents\WindowsPowershell\Modules\Autoload"
$ps_profile_dir = "$home\Documents\WindowsPowershell"
$terraform_version = "0.11.3"

echo "Building Docker image: $image_name with Terraform version: ${terraform_version} and log level ${log_level}"
docker build -t $image_name --build-arg terraform_version=$terraform_version ..

$terramorph_function = "
Function Invoke-Terramorph {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=`$false,
                   Position=0)]
        [alias(`"Action`")]
        [string]`$tf_argument
    )
    process 
    {
        if (`$PSBoundParameters.ContainsKey('tf_argument'))
        {
            docker run -i -t --rm ``
                --name $image_name ``
                -v `"$local_aws_dir`:$container_aws_dir`" ``
                -v `"$local_ssh_dir`:$container_ssh_dir`" ``
                -e log_level=`"$log_level`" ``
                $image_name ``
                `$tf_argument `
        }
        else
        {
            docker run -i -t --rm ``
                --name $image_name ``
                -v `"$local_aws_dir`:$container_aws_dir`" ``
                -v `"$local_ssh_dir`:$container_ssh_dir`" ``
                -e log_level=`"$log_level`" ``
                $image_name `
        }
    }
}"

# Ensure WindowsPowershell profile directory is present
# https://blogs.technet.microsoft.com/heyscriptingguy/2012/05/21/understanding-the-six-powershell-profiles/
$alias          ='Set-Alias -Name terramorph -Value Invoke-Terramorph -Description "Launches Terramorph container"'
$alias_short    ='Set-Alias -Name tm -Value Invoke-Terramorph -Description "Launches Terramorph container (short-name)"'

New-Item -ItemType Directory -Force -Path $ps_module_dir | Out-Null

# Configure Terramorph module
if (Test-Path $ps_module_dir\terramorph.psm1) {
    Remove-Item $ps_module_dir\terramorph.psm1 -Force | Out-Null
}
New-Item -path $ps_module_dir -name terramorph.psm1 -type "file" -value `
    "`n`n$terramorph_function`n`n$alias`n$alias_short`n" | Out-Null
Import-Module $ps_module_dir\terramorph.psm1
Write-Host "Created and imported new PS module: $ps_module_dir\terramorph.psm1"

# Configure Powershell profile to auto-load modules
$profile_content =  `
    "`nGet-ChildItem `"${ps_module_dir}\*.psm1`" | ForEach-Object{Import-Module `$_}
    Write-Host `"Custom PowerShell Environment Loaded`""

if (!(Test-Path $ps_profile_dir\profile.ps1)) {
    New-Item -path $ps_profile_dir -name profile.ps1 -type "file" -value $profile_content
    Write-Host "Created Powershell profile and configured module autoload: $ps_profile_dir\profile.ps1"
}
elseif (!(Get-Content $ps_profile_dir\profile.ps1 | Select-String "Custom PowerShell Environment Loaded")) {
    Add-Content -path $ps_profile_dir\profile.ps1 -value $profile_content
    Write-Host "Added alias to existing Powershell profile: $ps_profile_dir\profile.ps1" 
}