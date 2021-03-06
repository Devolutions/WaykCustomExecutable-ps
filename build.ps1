
$ModuleName = 'WaykCustomExecutable'

$CustomizerVersion = "0.1.5"

foreach ($TargetArch in @('x86', 'x64')) {
    $ArchName = if ($TargetArch -eq 'x86') { 'x86' } else { 'x86_64' }
    $OutputPath = Join-Path $PSScriptRoot "$ModuleName/bin/${TargetArch}"
    $OutputFile = Join-Path $OutputPath "WaykCustomizer.exe"
    New-Item -Path $OutputPath -ItemType 'Directory' -ErrorAction 'SilentlyContinue' | Out-Null
    $DownloadBaseUrl = 'https://github.com/Devolutions/wayk-cse/releases/download'
    $DownloadUrl = "${DownloadBaseUrl}/v${CustomizerVersion}/wayk-cse-patcher_windows_${CustomizerVersion}_${ArchName}.exe"
    $WebClient = [System.Net.WebClient]::new()
    $WebClient.DownloadFile($DownloadUrl, $OutputFile)
}
