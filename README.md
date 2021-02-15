# Wayk Custom Executable Patcher

Install PowerShell Module:

```PowerShell
Install-Module -Name WaykCustomExecutable -Scope AllUsers
Import-Module -Name WaykCustomExecutable
```

Install the [7-zip command-line tool](https://www.7-zip.org/) manually or using chocolatey (`choco install 7zip -y`). Make sure that the '7z' executable can be found in the system PATH:

```powershell
PS > where.exe 7z
C:\ProgramData\chocolatey\bin\7z.exe
```

Refer to the article on [Wayk Bastion deployment automation](https://docs.devolutions.net/wayk/bastion/deployment-automation.html) to create an enrollment token required for the automatic machine registration

Use the Wayk Bastion white-label editor and download the resulting branding.zip file (optional). The `-BrandingFile` parameter can be omitted if you do not intend to modify the application appearance with custom branding.

Invoke the `New-WaykCustomExecutable` command to create a new custom executable with the right parameters:

```PowerShell
New-WaykCustomExecutable `
    -DenUrl "https://bastion.contoso.com" `
    -TokenId "8ffc6813-af85-440a-aae5-b8a23c3084c3" `
    -BrandingFile ".\branding.zip" `
    -DestinationPath ".\output" `
    -DestinationName "MyCustomExecutable" `
    -Architecture "x64" `
    -EmbedMsi $false `
```

The `-DestinationPath` is where all output files are created, and the `-DestinationName` is the base name for output files. For the above command, the final custom executable will be ".\output\MyCustomExecutable.exe".

The `-EmbedMsi` option tells the custom patcher to include the MSI inside the executable, or download the latest version of the MSI on-the-fly. Embedding the MSI inside the executable means a larger file size, and the need to update the executable whenever a new version of the Wayk Agent comes out.
