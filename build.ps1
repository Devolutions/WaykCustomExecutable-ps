
$Version = "0.1.2"

$WebClient = [System.Net.WebClient]::new()
$DownloadBaseUrl = 'https://github.com/Devolutions/wayk-cse/releases/download'

foreach ($TargetArch in @('x86', 'x64')) {
    $ArchName = if ($TargetArch -eq 'x86') { 'x86' } else { 'x86_64' }
    New-Item -Path "bin/${TargetArch}" -ItemType 'Directory' -ErrorAction 'SilentlyContinue' | Out-Null
    $OutputFile = Join-Path $(Get-Location) "/bin/${TargetArch}/WaykCustomizer.exe"
    $DownloadUrl = "${DownloadBaseUrl}/v${Version}/wayk-cse-patcher_windows_${Version}_${ArchName}.exe"
    $WebClient.DownloadFile($DownloadUrl, $OutputFile)
}
