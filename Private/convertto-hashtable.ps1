function ConvertTo-Hashtable {
    <#
    .SYNOPSIS
        Converts a PSCustomObject to a Hashtable
    
    .DESCRIPTION
        Recursively converts a PSCustomObject to a Hashtable
    
    .PARAMETER InputObject
        The PSCustomObject to convert
        
    .EXAMPLE
        $customObject | ConvertTo-Hashtable
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$InputObject
    )
    
    process {
        if ($null -eq $InputObject) {
            return $null
        }
        
        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            $collection = @(
                foreach ($object in $InputObject) {
                    ConvertTo-Hashtable -InputObject $object
                }
            )
            
            return $collection
        }
        
        if ($InputObject -is [PSCustomObject]) {
            $hash = @{}
            
            foreach ($property in $InputObject.PSObject.Properties) {
                $hash[$property.Name] = ConvertTo-Hashtable -InputObject $property.Value
            }
            
            return $hash
        }
        
        return $InputObject
    }
}
