function Invoke-bconnectV2Patch {
    <#
    .SYNOPSIS
        Performs a PATCH request to the bconnectV2 API
    
    .DESCRIPTION
        Performs a PATCH request to the bconnectV2 API with retry logic
    
    .PARAMETER Endpoint
        API endpoint path to call
        
    .PARAMETER Body
        Body of the PATCH request containing the operations to perform
        
    .EXAMPLE
        Invoke-bconnectV2Patch -Endpoint "/v2.0/Endpoints/{id}" -Body $patchOperations
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Endpoint,
        
        [Parameter(Mandatory = $true)]
        [object]$Body
    )
    
    # Ensure we have a connection
    if (-not $script:bConnectUrl) {
        throw "Not connected to bconnectV2. Please run Initialize-bconnectV2 first."
    }
    
    # Build the request URL
    $requestUrl = $script:bConnectUrl + $Endpoint
    
    # Convert body to JSON if it's not already a string
    $bodyJson = if ($Body -is [string]) { $Body } else { $Body | ConvertTo-Json -Depth 20 }
    
    # Create headers with JSON Patch content type
    $headers = $script:bConnectSessionHeaders.Clone()
    $headers["Content-Type"] = "application/json-patch+json"
    
    # Retry logic
    $maxRetries = 3
    $retryCount = 0
    $success = $false
    $result = $null
    
    while (-not $success -and $retryCount -lt $maxRetries) {
        try {
            $params = @{
                Method = 'PATCH'
                Uri = $requestUrl
                Headers = $headers
                Authentication = 'Basic'
                Credential = $script:bConnectCredential
                Body = $bodyJson
                ErrorAction = 'Stop'
            }
            
            $response = Invoke-RestMethod @params
            $success = $true
            $result = $response
        }
        catch {
            $retryCount++
            
            if ($retryCount -ge $maxRetries) {
                Write-Error "Failed to perform PATCH request after $maxRetries attempts: $_"
                throw $_
            }
            else {
                $backoffSeconds = [math]::Pow(2, $retryCount)
                Write-Warning "PATCH request failed (attempt $retryCount of $maxRetries). Retrying in $backoffSeconds seconds..."
                Start-Sleep -Seconds $backoffSeconds
            }
        }
    }
    
    return $result
}
