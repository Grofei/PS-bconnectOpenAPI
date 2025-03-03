function Test-Guid {
    <#
    .SYNOPSIS
        Tests if a string is a valid GUID/UUID
    
    .DESCRIPTION
        Tests if a string is a valid GUID/UUID format
    
    .PARAMETER Guid
        The string to test
        
    .EXAMPLE
        Test-Guid -Guid "12345678-1234-1234-1234-123456789012"
        
    .EXAMPLE
        "12345678-1234-1234-1234-123456789012" | Test-Guid
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Guid
    )
    
    process {
        try {
            $guidObj = [System.Guid]::Parse($Guid)
            return $true
        }
        catch {
            return $false
        }
    }
}
