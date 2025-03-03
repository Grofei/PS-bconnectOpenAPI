function Invoke-bconnectV2Post {
    <#
    .SYNOPSIS
        Performs a POST request to the bconnectV2 API
    
    .DESCRIPTION
        Performs a POST request to the bconnectV2 API with retry logic
    
    .PARAMETER Endpoint
        API endpoint path to call
        
    .PARAMETER Body
        Body of the POST request
        
    .EXAMPLE
        Invoke-bconnectV2Post -Endpoint "/v2.0/Endpoints" -Body $bodyObject
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
    
    # Retry logic
    $maxRetries = 3
    $retryCount = 0
    $success = $false
    $result = $null
    
    while (-not $success -and $retryCount -lt $maxRetries) {
        try {
            $params = @{
                Method = 'POST'
                Uri = $requestUrl
                Headers = $script:bConnectSessionHeaders
                ContentType = 'application/json'
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
                Write-Error "Failed to perform POST request after $maxRetries attempts: $_"
                throw $_
            }
            else {
                $backoffSeconds = [math]::Pow(2, $retryCount)
                Write-Warning "POST request failed (attempt $retryCount of $maxRetries). Retrying in $backoffSeconds seconds..."
                Start-Sleep -Seconds $backoffSeconds
            }
        }
    }
    
    return $result
}
