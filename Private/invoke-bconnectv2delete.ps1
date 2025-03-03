function Invoke-bconnectV2Delete {
    <#
    .SYNOPSIS
        Performs a DELETE request to the bconnectV2 API
    
    .DESCRIPTION
        Performs a DELETE request to the bconnectV2 API with retry logic
    
    .PARAMETER Endpoint
        API endpoint path to call
        
    .EXAMPLE
        Invoke-bconnectV2Delete -Endpoint "/v2.0/Endpoints/{id}"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Endpoint
    )
    
    # Ensure we have a connection
    if (-not $script:bConnectUrl) {
        throw "Not connected to bconnectV2. Please run Initialize-bconnectV2 first."
    }
    
    # Build the request URL
    $requestUrl = $script:bConnectUrl + $Endpoint
    
    # Retry logic
    $maxRetries = 3
    $retryCount = 0
    $success = $false
    
    while (-not $success -and $retryCount -lt $maxRetries) {
        try {
            $params = @{
                Method = 'DELETE'
                Uri = $requestUrl
                Headers = $script:bConnectSessionHeaders
                ContentType = 'application/json'
                Authentication = 'Basic'
                Credential = $script:bConnectCredential
                ErrorAction = 'Stop'
            }
            
            $response = Invoke-RestMethod @params
            $success = $true
            return $response
        }
        catch {
            $retryCount++
            
            if ($retryCount -ge $maxRetries) {
                Write-Error "Failed to perform DELETE request after $maxRetries attempts: $_"
                throw $_
            }
            else {
                $backoffSeconds = [math]::Pow(2, $retryCount)
                Write-Warning "DELETE request failed (attempt $retryCount of $maxRetries). Retrying in $backoffSeconds seconds..."
                Start-Sleep -Seconds $backoffSeconds
            }
        }
    }
}
