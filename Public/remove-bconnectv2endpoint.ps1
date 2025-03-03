function Remove-bconnectV2Endpoint {
    <#
    .SYNOPSIS
        Removes an endpoint from the bconnectV2 API
    
    .DESCRIPTION
        Removes an endpoint from the bconnectV2 API by ID
    
    .PARAMETER Id
        The ID of the endpoint to remove
        
    .PARAMETER Confirm
        If specified, prompts for confirmation before removing the endpoint
        
    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs
        
    .EXAMPLE
        Remove-bconnectV2Endpoint -Id "12345678-1234-1234-1234-123456789012"
        
    .EXAMPLE
        Get-bconnectV2Endpoint -Id "12345678-1234-1234-1234-123456789012" | Remove-bconnectV2Endpoint
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
        if ($PSCmdlet.ShouldProcess("Endpoint with ID '$Id'", "Remove")) {
            # Make the API call
            try {
                $response = Invoke-bconnectV2Delete -Endpoint "/endpoints/v2.0/Endpoints/$Id"
                
                # Return success message
                Write-Verbose "Endpoint with ID '$Id' was successfully removed"
                return $true
            }
            catch {
                Write-Error "Failed to remove endpoint with ID '$Id': $_"
                throw $_
            }
        }
    }
}
