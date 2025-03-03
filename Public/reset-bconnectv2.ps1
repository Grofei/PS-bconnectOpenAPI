function Reset-bconnectV2 {
    <#
    .SYNOPSIS
        Resets the bconnectV2 connection
    
    .DESCRIPTION
        Resets the bconnectV2 connection by clearing the stored connection information
    
    .EXAMPLE
        Reset-bconnectV2
    #>
    [CmdletBinding()]
    param()
    
    # Clear all connection variables
    $script:bConnectUrl = $null
    $script:bConnectCredential = $null
    $script:bConnectServerVersion = $null
    $script:bConnectSessionHeaders = $null
    
    Write-Verbose "bconnectV2 connection has been reset"
}
