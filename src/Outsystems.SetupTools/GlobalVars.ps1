# Outsystems services
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSServices = @(
    "OutSystems Log Service",
    "OutSystems Deployment Controller Service",
    "OutSystems Deployment Service",
    "OutSystems Scheduler Service",
    "OutSystems SMS Connector Service"
)

# Outsystems base windows features
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSWindowsFeaturesBase = @(
    "Web-Default-Doc", "Web-Dir-Browsing", "Web-Http-Errors", "Web-Static-Content",
    "Web-Http-Logging", "Web-Request-Monitor",
    "Web-Stat-Compression", "Web-Dyn-Compression",
    "Web-Filtering", "Web-Windows-Auth", `
    "Web-Net-Ext45", "Web-Asp-Net45", "Web-ISAPI-Ext", "Web-ISAPI-Filter",
    "Web-Metabase",
    "WAS-Config-APIs", "WAS-Process-Model"
)

# Hardware requirements
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSReqsMinCores = 2
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSReqsMinRAMGB = 4

# Software and operating system requirements
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSReqsMinOSVersion = "6.2.0.0"
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSReqsMinOSProductType = 2
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OS10ReqsMinDotNetVersion = "394254"
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OS11ReqsMinDotNetVersion = "461308"

# Windows event log configs
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSWinEventLogSize = 20480KB
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSWinEventLogOverflowAction = "OverwriteAsNeeded"
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSWinEventLogName = @(
    "Security",
    "Application",
    "System"
)

# Default install directories
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSDefaultInstallDir = "$Env:ProgramFiles\OutSystems"

# Default Service Center credentials
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSSCUser = "admin"
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSSCPass = "admin"

# Sources repo
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSRepoURL = "https://myfilerepo.blob.core.windows.net/sources"
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSRepoURLDotNET = 'https://download.microsoft.com/download/9/E/6/9E63300C-0941-4B45-A0EC-0008F96DD480/NDP471-KB4033342-x86-x64-AllOS-ENU.exe'
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSRepoURLBuildTools = 'https://download.microsoft.com/download/E/E/D/EEDF18A8-4AED-4CE0-BEBE-70A83094FC5A/BuildTools_Full.exe'

# Database default timeout
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSDBTimeout = "60"

# Log related
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSLogFile = ""
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSLogDebug = $false

# IIS configuration
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$OSIISConfig = @(
    @{
        'PoolName' = 'OutSystemsApplications';
        'MemoryPercentage' = 60;
        'Match' = @('*')
    },
    @{
        'PoolName' = 'ServiceCenterAppPool';
        'MemoryPercentage' = 100;
        'Match' = @('/ServiceCenter')
    },
    @{
        'PoolName' = 'LifeTimeAppPool';
        'MemoryPercentage' = 60;
        'Match' = @('/LT*','/lifet*','/LifeT*','PerformanceMonitor')
    }
)
