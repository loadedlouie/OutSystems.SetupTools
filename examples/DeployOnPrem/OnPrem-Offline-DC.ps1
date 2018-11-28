[CmdletBinding()]
param(
    [Parameter()]
    [string]$InstallDir = $("$env:ProgramFiles\OutSystems")
)

# -- Stop on any error
$ErrorActionPreference = 'Stop'

# -- Import configuration file
$OfflineConfiguration = Import-Clixml "$PSScriptRoot\Configuration.xml"
$majorVersion = "$($([version]$OfflineConfiguration.ServerVersion).Major).$($([version]$OfflineConfiguration.ServerVersion).Minor)"

# -- Import module from local folder
Import-Module -Name "$PSScriptRoot\Modules\AzureRM.profile" | Out-Null
Import-Module -Name "$PSScriptRoot\Modules\Azure.Storage" | Out-Null
Import-Module -Name "$PSScriptRoot\Modules\AzureRM.Storage" | Out-Null
Import-Module -Name "$PSScriptRoot\Modules\Outsystems.SetupTools" | Out-Null

# -- Check HW and OS for compability
Test-OSServerHardwareReqs -MajorVersion $majorVersion -Verbose -ErrorAction Stop | Out-Null
Test-OSServerSoftwareReqs -MajorVersion $majorVersion -Verbose -ErrorAction Stop | Out-Null

# -- Install PreReqs
Install-OSServerPreReqs -MajorVersion $MajorVersion -SourcePath "$PSScriptRoot\PreReqs" -Verbose -ErrorAction Stop | Out-Null

# -- Download and install OS Server and Dev environment from repo
Install-OSServer -Version $OfflineConfiguration.ServerVersion -InstallDir $InstallDir -SourcePath "$PSScriptRoot\Sources" -Verbose -ErrorAction Stop | Out-Null
Install-OSServiceStudio -Version $OfflineConfiguration.ServiceStudioVersion -InstallDir $InstallDir -SourcePath "$PSScriptRoot\Sources" -Verbose -ErrorAction Stop | Out-Null

# Start configuration tool
Write-Output "Launching the configuration tool... "
& "$InstallDir\Platform Server\ConfigurationTool.exe"
[void](Read-Host 'Configure the platform and press Enter to continue the OutSystems setup...')

# -- Install service center and publish system components
Install-OSPlatformServiceCenter -Verbose -ErrorAction Stop | Out-Null
Publish-OSPlatformSystemComponents -Verbose -ErrorAction Stop | Out-Null

# -- Apply system tunning and security settings
Set-OSServerPerformanceTunning -Verbose -ErrorAction Stop | Out-Null
Set-OSServerSecuritySettings -Verbose -ErrorAction Stop | Out-Null
