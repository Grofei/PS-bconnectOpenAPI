function Start-bconnectV2WindowsEndpointEnrollment {
    <#
    .SYNOPSIS
        Starts the enrollment process for a Windows endpoint
    
    .DESCRIPTION
        Starts the enrollment process for a Windows endpoint by triggering the enrollment state.
        This sets the endpoint to Internet mode, deletes its stored public key (if existing) and 
        generates / overwrites the enrollment data of this endpoint.
    
    .PARAMETER Id
        The ID of the Windows endpoint to enroll
        
    .PARAMETER EnrollmentMailAddress
        The email address to send the enrollment information to
        
    .PARAMETER EmailLanguageId
        The language ID for the email template (default: "en-US")
        
    .PARAMETER Sync
        Whether to wait until the email has been successfully sent to the configured SMTP server (default: $false)
        
    .EXAMPLE
        Start-bconnectV2WindowsEndpointEnrollment -Id "12345678-1234-1234-1234-123456789012"
        
    .EXAMPLE
        Get-bconnectV2WindowsEndpoint -Id "12345678-1234-1234-1234-123456789012" | Start-bconnectV2WindowsEndpointEnrollment -EnrollmentMailAddress "user@example.com"
        
    .EXAMPLE
        Start-bconnectV2WindowsEndpointEnrollment -Id "12345678-1234-1234-1234-123456789012" -EnrollmentMailAddress "user@example.com" -EmailLanguageId "de-DE" -Sync $true
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("EndpointId")]
        [string]$Id,
        
        [Parameter(Mandatory = $false)]
        [string]$EnrollmentMailAddress,
        
        [Parameter(Mandatory = $false)]
        [string]$EmailLanguageId = "en-US",
        
        [Parameter(Mandatory = $false)]
        [bool]$Sync = $false
    )
    
    process {
        # Validate the ID is a valid GUID
        if (-not (Test-Guid -Guid $Id)) {
            Write-Error "Invalid endpoint ID format. ID must be a valid GUID."
            return
        }
        
        # Build the request body
        $body = @{
            sync = $Sync
        }
        
        if ($EnrollmentMailAddress) {
            $body["enrollmentMailAddress"] = $EnrollmentMailAddress
            $body["emailLanguageId"] = $EmailLanguageId
        }
        
        # Make the API call
        try {
            $response = Invoke-bconnectV2Post -Endpoint "/endpoints/v2.0/WindowsEndpoints/$Id/StartEnrollment" -Body $body
            
            # Return the enrollment response
            return $response
        }
        catch {
            Write-Error "Failed to start enrollment for Windows endpoint with ID '$Id': $_"
            throw $_
        }
    }
}
