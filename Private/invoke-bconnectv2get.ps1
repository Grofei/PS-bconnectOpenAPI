function Invoke-bconnectV2Get {
    <#
    .SYNOPSIS
        Performs a GET request to the bconnectV2 API
    
    .DESCRIPTION
        Performs a GET request to the bconnectV2 API with retry logic
    
    .PARAMETER Endpoint
        API endpoint path to call
        
    .PARAMETER QueryParameters
        Hashtable of query parameters to include in the request
        
    .EXAMPLE
        Invoke-bconnectV2Get -Endpoint "/v2.0/Endpoints"
        
    .EXAMPLE
        Invoke-bconnectV2Get -Endpoint "/v2.0/Endpoints/{id}" -QueryParameters @{id = "12345678-1234-1234-1234-123456789012"}
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Endpoint,
        
        [Parameter(Mandatory = $false)]
        [hashtable]$QueryParameters = @{}
    )
    
    # Ensure we have a connection
    if (-not $script:bConnectUrl) {
        throw "Not connected to bconnectV2. Please run Initialize-bconnectV2 first."
    }
    
    # Build the request URL
    $requestUrl = $script:bConnectUrl + $Endpoint
    
    # Add query parameters if provided
    if ($QueryParameters.Count -gt 0) {
        $queryString = [System.Web.HttpUtility]::ParseQueryString([string]::Empty)
        foreach ($key in $QueryParameters.Keys) {
            $queryString[$key] = $QueryParameters[$key]
        }
        
        # Append query string to request URL
        if ($queryString.Count -gt 0) {
            $requestUrl += "?" + $queryString.ToString()
        }
    }
    
    # Retry logic
    $maxRetries = 3
    $retryCount = 0
    $success = $false
    $result = $null
    
    while (-not $success -and $retryCount -lt $maxRetries) {
        try {
            $params = @{
                Method = 'GET'
                Uri = $requestUrl
                Headers = $script:bConnectSessionHeaders
                ContentType = 'application/json'
                Authentication = 'Basic'
                Credential = $script:bConnectCredential
                ErrorAction = 'Stop'
            }
            
            $response = Invoke-RestMethod @params
            $success = $true
            $result = $response
        }
        catch {
            $retryCount++
            
            if ($retryCount -ge $maxRetries) {
                Write-Error "Failed to perform GET request after $maxRetries attempts: $_"
                throw $_
            }
            else {
                $backoffSeconds = [math]::Pow(2, $retryCount)
                Write-Warning "GET request failed (attempt $retryCount of $maxRetries). Retrying in $backoffSeconds seconds..."
                Start-Sleep -Seconds $backoffSeconds
            }
        }
    }
    
    return $result
}
