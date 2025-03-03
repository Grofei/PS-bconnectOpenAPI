function Initialize-bconnectV2 {
    <#
    .SYNOPSIS
        Initializes a connection to the bconnectV2 API
    
    .DESCRIPTION
        Initializes a connection to the bconnectV2 API and stores the connection information for use by other cmdlets
    
    .PARAMETER Server
        The server name or IP address of the Baramundi Management Server
        
    .PARAMETER Credential
        The credentials to use for authentication
        
    .PARAMETER Port
        The port to use for the connection (default: 443)
        
    .PARAMETER UseSSL
        Whether to use SSL for the connection (default: $true)
        
    .EXAMPLE
        Initialize-bconnectV2 -Server "bms.example.com" -Credential (Get-Credential)
        
    .EXAMPLE
        Initialize-bconnectV2 -Server "bms.example.com" -Credential (Get-Credential) -Port 8443
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential,
        
        [Parameter(Mandatory = $false)]
        [int]$Port = 443,
        
        [Parameter(Mandatory = $false)]
        [bool]$UseSSL = $true
    )
    
    # Build the base URL
    $protocol = if ($UseSSL) { "https" } else { "http" }
    $script:bConnectUrl = "$protocol`://$Server`:$Port/bconnect"
    
    # Store the credentials for later use
    $script:bConnectCredential = $Credential
    
    # Set up session headers
    $script:bConnectSessionHeaders = @{
        "Accept" = "application/json"
    }
    
    # Test the connection by making a basic request
    try {
        Write-Verbose "Testing connection to bconnectV2 API at $script:bConnectUrl"
        
        # Try to access the endpoints base URL to verify the connection
        $params = @{
            Method = 'GET'
            Uri = "$script:bConnectUrl/endpoints/v2.0/Endpoints"
            Headers = $script:bConnectSessionHeaders
            ContentType = 'application/json'
            Authentication = 'Basic'
            Credential = $script:bConnectCredential
            ErrorAction = 'Stop'
        }
        
        $response = Invoke-RestMethod @params
        
        Write-Verbose "Successfully connected to bconnectV2 API"
        
        # Return connection information
        return [PSCustomObject]@{
            Server = $Server
            Port = $Port
            UseSSL = $UseSSL
            Connected = $true
            Url = $script:bConnectUrl
        }
    }
    catch {
        Write-Error "Failed to connect to bconnectV2 API: $_"
        
        # Clear the connection variables
        $script:bConnectUrl = $null
        $script:bConnectCredential = $null
        $script:bConnectSessionHeaders = $null
        
        throw $_
    }
}
