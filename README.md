# Wayk Custom Executable Patcher

```PowerShell
Install-Module -Name WaykCustomExecutable -Scope AllUsers
Import-Module -Name WaykCustomExecutable
```

```PowerShell
New-WaykCustomExecutable `
    -DenUrl "https://bastion.contoso.com" `
    -TokenId "8ffc6813-af85-440a-aae5-b8a23c3084c3" `
    -BrandingFile ".\branding.zip" `
    -DestinationPath ".\output" `
    -DestinationName "MyCustomExecutable" `
    -Architecture "x86"
```
