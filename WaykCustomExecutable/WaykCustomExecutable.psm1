
$ModuleName = $(Get-Item $PSCommandPath).BaseName
$Manifest = Import-PowerShellDataFile -Path $(Join-Path $PSScriptRoot "${ModuleName}.psd1")

if (-Not (Test-Path 'variable:global:IsWindows')) {
    $script:IsWindows = $true; # Windows PowerShell 5.1 or earlier
}

if ($IsWindows) {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
}

function Get-WaykCustomizer
{
    [CmdletBinding()]
	param(
        [Parameter(Mandatory=$true)]
        [string] $DestinationPath,
        [ValidateSet("x86","x64")]
        [string] $Architecture = "x64"
    )

    $Version = "0.1.5"
    $WebClient = [System.Net.WebClient]::new()
    $DownloadBaseUrl = 'https://github.com/Devolutions/wayk-cse/releases/download'
    
    foreach ($TargetArch in @('x86', 'x64')) {
        $ArchName = if ($TargetArch -eq 'x86') { 'x86' } else { 'x86_64' }
        New-Item -Path "$DestinationPath/bin/${TargetArch}" -ItemType 'Directory' -ErrorAction 'SilentlyContinue' | Out-Null
        $OutputFile = Join-Path $DestinationPath "/bin/${TargetArch}/WaykCustomizer.exe"

        if (-Not (Test-Path $OutputFile -PathType 'Leaf')) {
            $DownloadUrl = "${DownloadBaseUrl}/v${Version}/wayk-cse-patcher_windows_${Version}_${ArchName}.exe"
            $WebClient.DownloadFile($DownloadUrl, $OutputFile)
        }
    }

    $WaykCustomizer = "$DestinationPath/bin/${Architecture}/WaykCustomizer.exe"

    return $WaykCustomizer
}

function New-WaykCustomExecutable
{
    [CmdletBinding()]
	param(
        [Parameter(Mandatory=$true)]
        [string] $DenUrl,
        [Parameter(Mandatory=$true)]
        [string] $TokenId,
        [string] $BrandingFile,
        [Parameter(Mandatory=$true)]
        [string] $DestinationPath,
        [ValidateScript({
            if( $_.StartsWith("wayk", "CurrentCultureIgnoreCase"))
            {
                throw 'DestinationName may not start with "wayk"'
            }
            else {
                $true
            }
        })]
        [string] $DestinationName = "CustomWayk",
        [ValidateSet("x86","x64")]
        [string] $Architecture = "x64",
        [bool] $StartAfterInstall = $true,
        [bool] $EmbedMsi = $false,
        [bool] $Quiet = $false,

        [bool] $AnalyticsEnabled = $true,
        [bool] $AutoUpdateEnabled = $true,
        [bool] $CrashReporterAutoUpload = $true,
        [bool] $CrashReporterEnabled = $true,

        [bool] $AutoLaunchOnUserLogon = $false,
        [bool] $MinimizeToNotificationArea = $false,
        [bool] $ShowMainWindowOnLaunch = $true,
        [string] $FriendlyName,
        [string] $Language,

        [bool] $AllowNoPassword = $true,
        [bool] $AllowPersonalPassword = $true,
        [bool] $AllowSystemAuth = $true,
        [bool] $GeneratedPasswordAutoReset = $true,
        [string] $GeneratedPasswordCharSet,
        [bool] $GeneratedPasswordLength
    )
    
    if ($TokenId) {
        if ($TokenId -NotMatch '^\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$') {
            throw "TokenId is incorrectly formatted (UUID expected): $TokenId"
        }
    }

    if ($BrandingFile) {
        if (-Not (Test-Path $BrandingFile -PathType 'Leaf')) {
            throw "branding zip file cannot be found: $BrandingFile"
        }
        $BrandingFile = Resolve-Path $BrandingFile
    }

    $DestinationPath = $PSCmdlet.GetUnresolvedProviderPathFromPSPath($DestinationPath)
    $ConfigFile = Join-Path $DestinationPath "$DestinationName.json"
    $OutputFile = Join-Path $DestinationPath "$DestinationName.exe"

    $enrollment = $null
    $branding = $null
    $config = $null
    $install = $null

    if ($TokenId -and $DenUrl) {
        $enrollment = [PSCustomObject]@{
            url = $DenUrl
            token = $TokenId
        }
    }

    if ($BrandingFile) {
        $branding = [PSCustomObject]@{
            embedded = $true
            path = $BrandingFile
        }
    }

    $config = [PSCustomObject]@{}

    @(
        'AnalyticsEnabled',
        'AutoUpdateEnabled',
        'CrashReporterAutoUpload',
        'CrashReporterEnabled',
        'AutoLaunchOnUserLogon',
        'MinimizeToNotificationArea',
        'ShowMainWindowOnLaunch',
        'FriendlyName',
        'Language',
        'AllowNoPassword',
        'AllowPersonalPassword',
        'AllowSystemAuth',
        'GeneratedPasswordAutoReset',
        'GeneratedPasswordCharSet',
        'GeneratedPasswordLength'
    ) | ForEach-Object {
        $PropertyName = $_
        if ($PSBoundParameters.ContainsKey($PropertyName)) {
            $PropertyValue = $PSBoundParameters[$PropertyName]
            $config | Add-Member -Type NoteProperty -Name $PropertyName -Value $PropertyValue
        }
    }

    $install = [PSCustomObject]@{
        embedMsi = $EmbedMsi
        quiet = $Quiet
        architecture = $Architecture
        startAfterInstall = $StartAfterInstall
    }

    $custom = [PSCustomObject] @{ }
    $custom | Add-Member -Type NoteProperty -Name "enrollment" -Value $enrollment
    $custom | Add-Member -Type NoteProperty -Name "branding" -Value $branding
    $custom | Add-Member -Type NoteProperty -Name "config" -Value $config
    $custom | Add-Member -Type NoteProperty -Name "install" -Value $install

    $ConfigData = $custom | ConvertTo-Json -Depth 5

    $AsByteStream = if ($PSEdition -eq 'Core') { @{AsByteStream = $true} } else { @{'Encoding' = 'Byte'} }
    $ConfigBytes = $([System.Text.Encoding]::UTF8).GetBytes($ConfigData)

    New-Item -Path $DestinationPath -ItemType 'Directory' -ErrorAction 'SilentlyContinue' | Out-Null
    Set-Content -Path $ConfigFile -Value $ConfigBytes @AsByteStream -Force

    $WaykCustomizer = "$PSScriptRoot/bin/${Architecture}/WaykCustomizer.exe"

    Write-Host $WaykCustomizer

    & $WaykCustomizer "-c" $ConfigFile "-o" $OutputFile
}

Export-ModuleMember -Function @($Manifest.FunctionsToExport)
