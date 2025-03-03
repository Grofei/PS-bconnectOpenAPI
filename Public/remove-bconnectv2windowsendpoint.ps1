function Remove-bconnectV2WindowsEndpoint {
    <#
    .SYNOPSIS
        Removes a Windows endpoint from the bconnectV2 API
    
    .DESCRIPTION
        Removes a Windows endpoint from the bconnectV2 API by ID
    
    .PARAMETER Id
        The ID of the Windows endpoint to remove
        
    .PARAMETER Confirm
        If specified, prompts for confirmation before removing the endpoint
        
    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs
        
    .EXAMPLE
        Remove-bconnectV2WindowsEndpoint -Id "12345678-1234-1234-1234-123456789012"
        
    .EXAMPLE
        Get-bconnectV2WindowsEndpoint -Id "12345678-1234-1234-1234-123456789012" | Remove-bconnectV2WindowsEndpoint
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("EndpointId")]
        [string]$Id
    )
    
    process {
        # Validate the ID is a valid GUID
        if (-not (Test-Guid -Guid $Id)) {
            Write-Error "Invalid endpoint ID format. ID must be a valid GUID."
            return
        }
        
        # Confirm the deletion
        if ($PSCmdlet.ShouldProcess("Windows Endpoint with ID '$Id'", "Remove")) {
            # Make the API call
            try {
                $response = Invoke-bconnectV2Delete -Endpoint "/endpoints/v2.0/WindowsEndpoints/$Id"
                
                # Return success message
                Write-Verbose "Windows Endpoint with ID '$Id' was successfully removed"
                return $true
            }
            catch {
                Write-Error "Failed to remove Windows endpoint with ID '$Id': $_"
                throw $_
            }
        }
    }
}
