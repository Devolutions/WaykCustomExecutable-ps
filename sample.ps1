
function Get-WaykCustomizer
{
    $TargetArch = "x86"
    $BinBasePath = Join-Path $(Get-Location) "bin"
    $BinArchPath = Join-Path $BinBasePath $TargetArch
    $WaykCustomizer = Join-Path $BinArchPath "WaykCustomizer.exe"
    return $WaykCustomizer
}

$WaykCustomizer = Get-WaykCustomizer

$InputPath = Join-Path $(Get-Location) "sample"
$OutputPath = Join-Path $(Get-Location) "output"

$OptionFile = Join-Path $InputPath "options.json"
$OutputFile = Join-Path $OutputPath "WaykCustom.exe"

New-Item -Path $OutputPath -ItemType 'Directory' -ErrorAction 'SilentlyContinue' | Out-Null

Push-Location
Set-Location $InputPath
& $WaykCustomizer "-c" $OptionFile "-o" $OutputFile
Pop-Location
