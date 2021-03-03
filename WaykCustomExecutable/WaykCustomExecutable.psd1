#
# Module manifest for module 'WaykClient'
#
# Generated by: Devolutions
#
# Generated on: 19-09-15
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'WaykCustomExecutable.psm1'

# Version number of this module.
ModuleVersion = '2021.1.1'

# Supported PSEditions
CompatiblePSEditions = 'Desktop', 'Core'

# ID used to uniquely identify this module
GUID = '91705110-bb96-4f8a-ba13-d1679f3a8cbf'

# Author of this module
Author = 'Devolutions'

# Company or vendor of this module
CompanyName = 'Devolutions'

# Copyright statement for this module
Copyright = '(c) 2019-2021 Devolutions Inc. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Devolutions Wayk Custom Executable PowerShell Module'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
DotNetFrameworkVersion = '4.7.2'

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
CLRVersion = '4.0'

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('New-WaykCustomExecutable')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'Wayk', 'Custom', 'Agent', 'WaykBastion', 'Windows', 'macOS', 'Linux', 'RemoteDesktop'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/Devolutions/WaykCustomExecutable-ps/blob/master/LICENSE-MIT'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/Devolutions/WaykCustomExecutable-ps'

        # A URL to an icon representing this module.
        IconUri = 'https://raw.githubusercontent.com/Devolutions/WaykCustomExecutable-ps/master/logo.png'

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        #Prerelease = 'rc1'

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
