# bconnectV2.psm1
# Main module file for bconnectOpenAPI PowerShell module

# Global variables to store connection information
$script:bConnectUrl = $null
$script:bConnectCredential = $null
$script:bConnectServerVersion = $null
$script:bConnectSessionHeaders = $null

# Import all private functions
$PrivateFunctions = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)
foreach ($Function in $PrivateFunctions) {
    try {
        . $Function.FullName
    }
    catch {
        Write-Error -Message "Failed to import function $($Function.FullName): $_"
    }
}

# Import all public functions
$PublicFunctions = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
foreach ($Function in $PublicFunctions) {
    try {
        . $Function.FullName
    }
    catch {
        Write-Error -Message "Failed to import function $($Function.FullName): $_"
    }
}

# Import all type definitions
$TypeFiles = @(Get-ChildItem -Path $PSScriptRoot\Types\*.ps1 -ErrorAction SilentlyContinue)
foreach ($TypeFile in $TypeFiles) {
    try {
        . $TypeFile.FullName
    }
    catch {
        Write-Error -Message "Failed to import type definition $($TypeFile.FullName): $_"
    }
}

# Export the public functions
Export-ModuleMember -Function $PublicFunctions.BaseName
