function Get-bconnectV2Endpoint {
    <#
    .SYNOPSIS
        Gets a specific endpoint from the bconnectV2 API
    
    .DESCRIPTION
        Gets a specific endpoint from the bconnectV2 API by ID
    
    .PARAMETER Id
        The ID of the endpoint to retrieve
        
    .EXAMPLE
        Get-bconnectV2Endpoint -Id "12345678-1234-1234-1234-123456789012"
        
    .EXAMPLE
        "12345678-1234-1234-1234-123456789012" | Get-bconnectV2Endpoint
    #>
    [CmdletBinding()]
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
        
        # Make the API call
        try {
            $response = Invoke-bconnectV2Get -Endpoint "/endpoints/v2.0/Endpoints/$Id"
            return $response
        }
        catch {
            Write-Error "Failed to get endpoint with ID '$Id': $_"
            throw $_
        }
    }
}
