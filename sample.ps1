
function Get-WaykCustomizer
{
    [CmdletBinding()]
	param(
        [Parameter(Mandatory=$true)]
        [string] $DestinationPath,
        [ValidateSet("x86","x64")]
        [string] $Architecture = "x64"
    )

    $Version = "0.1.2"
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
        [string] $DestinationName = "WaykCustom",
        [ValidateSet("x86","x64")]
        [string] $Architecture = "x64",
        [bool] $AutoUpdateEnabled = $true,
        [bool] $EmbedMsi = $false,
        [bool] $StartAfterInstall = $true
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

    $config = [PSCustomObject]@{
        autoUpdateEnabled = $AutoUpdateEnabled
    }

    $install = [PSCustomObject]@{
        embedMsi = $EmbedMsi
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

    $WaykCustomizer = Get-WaykCustomizer -Architecture:$Architecture -DestinationPath $PSScriptRoot
    & $WaykCustomizer "-c" $ConfigFile "-o" $OutputFile
}

New-WaykCustomExecutable `
    -DenUrl "https://bastion.contoso.com" `
    -TokenId "8ffc6813-af85-440a-aae5-b8a23c3084c3" `
    -BrandingFile ".\branding.zip" `
    -DestinationPath ".\output" `
    -DestinationName "MyCustomExecutable" `
    -Architecture "x64"
