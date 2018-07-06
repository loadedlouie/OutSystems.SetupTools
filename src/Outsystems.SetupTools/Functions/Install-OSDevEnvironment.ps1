Function Install-OSDevEnvironment {
    <#
    .SYNOPSIS
    Installs or updates the Outsystems development environment.

    .DESCRIPTION
    This will installs or updates the development environment.
    If the development environment is already installed it will check if version to be installed is higher than the current one.
    If the development environment is already installed with an higher version it will throw an exception.


    .PARAMETER InstallDir
    Where the development environment will be installed. If the development environment is already installed, this parameter has no effect.
    If not specified will default to %ProgramFiles%\Outsystems

    .PARAMETER SourcePath
    If specified, the function will use the sources in that path. If not specified it will download the sources from the Outsystems repository.

    .PARAMETER Version
    The version to be installed.

    .EXAMPLE
    Install-OSDevEnvironment -Version "10.0.823.0"
    Install-OSDevEnvironment -Version "10.0.823.0" -InstallDir D:\Outsystems
    Install-OSDevEnvironment -Version "10.0.823.0" -InstallDir D:\Outsystems -SourcePath c:\temp

    #>

    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName = 'Local')]
        [Parameter(ParameterSetName = 'Remote')]
        [string]$InstallDir = $OSDefaultInstallDir,

        [Parameter(ParameterSetName = 'Local', Mandatory = $true)]
        [string]$SourcePath,

        [Parameter(ParameterSetName = 'Local', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Remote', Mandatory = $true)]
        [string]$Version
    )

    Begin {
        LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 0 -Message "Starting"
        Write-Output "Starting the Outsystems development environment installation. This can take a while... Please wait..."
        Try{
            CheckRunAsAdmin | Out-Null
        }
        Catch{
            LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 3 -Message "The current user is not Administrator or not running this script in an elevated session"
            Throw "The current user is not Administrator or not running this script in an elevated session"
        }

        Try {
            $OSVersion = GetDevEnvVersion -MajorVersion "$(([System.Version]$Version).Major).$(([System.Version]$Version).Minor)"
            $OSInstallDir = GetDevEnvInstallDir -MajorVersion "$(([System.Version]$Version).Major).$(([System.Version]$Version).Minor)"
        }
        Catch {}

        If ( -not $OSVersion ) {
            LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 1 -Message "Outsystems development environment is not installed"
            LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 1 -Message "Proceeding with normal installation"
            $InstallDir = "$InstallDir\Development Environment $(([System.Version]$Version).Major).$(([System.Version]$Version).Minor)"
            $DoInstall = $true
        }
        ElseIf ( [version]$OSVersion -lt [version]$Version) {
            LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 1 -Message "Outsystems development environment already installed. Updating!!"
            LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 1 -Message "Current version $OSVersion will be updated to $Version"
            LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 1 -Message "Ignoring InstallDir since this is an update"
            $InstallDir = $OSInstallDir
            $DoInstall = $true
        }
        ElseIf ( [version]$OSVersion -gt [version]$Version) {
            $DoInstall = $false
            LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 3 -Message "Outsystems development environment already installed with an higher version $OSVersion"
            Throw "Outsystems development environment already installed with an higher version $OSVersion"
        }
        Else {
            $DoInstall = $false
            LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 1 -Message "Outsystems development environment already installed with the specified version $OSVersion"
        }
    }

    Process {
        If ( $DoInstall ) {

            LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 1 -Message "Installing version $Version"
            LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 1 -Message "Installing in $InstallDir"

            #Check if installer is local or is to be downloaded.
            switch ($PsCmdlet.ParameterSetName) {
                "Remote" {
                    LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 1 -Message "SourcePath not specified. Downloading installer from repository"

                    $Installer = "$ENV:TEMP\DevelopmentEnvironment-$Version.exe"
                    LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 1 -Message "Saving installer to $Installer"

                    Try {
                        DownloadOSSources -URL "$OSRepoURL\DevelopmentEnvironment-$Version.exe" -SavePath $Installer
                    }
                    Catch {
                        LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 3 -Message "Error downloading the installer from repository. Check if version is correct"
                        Throw "Error downloading the installer from repository. Check if version is correct"
                    }

                }
                "Local" {
                    LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 1 -Message "SourcePath specified. Using the local installer"
                    $Installer = "$SourcePath\DevelopmentEnvironment-$Version.exe"
                    If ( -not (Test-Path -Path $Installer)) {
                        LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 3 -Message "Cant file the setup file at $Installer"
                        Throw "Cant file the setup file at $Installer"
                    }
                }
            }

            LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 1 -Message "Starting the installation. This can take a while..."
            $IntReturnCode = Start-Process -FilePath $Installer -ArgumentList "/S", "/D=$InstallDir" -Wait -PassThru
            If ( $IntReturnCode.ExitCode -ne 0 ) {
                LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 3 -Message "Error installing Outsystems development environment. Exit code: $($IntReturnCode.ExitCode)"
                throw "Error installing Outsystems development environment. Exit code: $($IntReturnCode.ExitCode)"
            }
            LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 1 -Message "Outsystems development environment server successfully installed."
        }
    }

    End {
        Write-Output "Outsystems development environment successfully installed!! Version $Version"
        LogVerbose -FuncName $($MyInvocation.Mycommand) -Phase 2 -Message "Ending"
    }
}