function New-bconnectV2WindowsEndpoint {
    <#
    .SYNOPSIS
        Creates a new Windows endpoint in the bconnectV2 API
    
    .DESCRIPTION
        Creates a new Windows endpoint in the bconnectV2 API with the specified properties
    
    .PARAMETER DisplayName
        The display name of the endpoint (required)
        
    .PARAMETER LogicalGroupId
        The ID of the logical group to assign the endpoint to
        
    .PARAMETER Comment
        A comment to add to the endpoint
        
    .PARAMETER HostName
        The hostname of the endpoint
        
    .PARAMETER Domain
        The domain of the endpoint
        
    .PARAMETER PrimaryMAC
        The primary MAC address of the endpoint
        
    .PARAMETER PrimaryIP
        The primary IP address of the endpoint
        
    .PARAMETER PrimarySubnetMask
        The primary subnet mask of the endpoint
        
    .PARAMETER RegisteredUser
        The registered user of the endpoint
        
    .PARAMETER RegisteredUserUpdateMode
        The registered user update mode (UseNextLogonUser, DoNotUseRegisteredUser, UpdateContinously, EnterManually)
        
    .PARAMETER UserRelatedJobExecution
        The user related job execution mode (Always, Never, ForRegisteredUser)
        
    .PARAMETER IsEnergyManagementActive
        Whether energy management is active for the endpoint
        
    .PARAMETER NetworkMode
        The network mode for the client agent (LAN, Internet, Dynamic)
        
    .PARAMETER ExtendedInternetMode
        Whether extended internet mode is enabled for the client agent
        
    .PARAMETER UUID
        The UUID of the endpoint
        
    .EXAMPLE
        New-bconnectV2WindowsEndpoint -DisplayName "Server01" -HostName "Server01" -Domain "contoso.com" -LogicalGroupId "12345678-1234-1234-1234-123456789012"
        
    .EXAMPLE
        New-bconnectV2WindowsEndpoint -DisplayName "Client01" -HostName "Client01" -PrimaryIP "192.168.1.100" -PrimarySubnetMask "255.255.255.0" -RegisteredUser "user@contoso.com" -NetworkMode "Dynamic"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DisplayName,
        
        [Parameter(Mandatory = $false)]
        [string]$LogicalGroupId,
        
        [Parameter(Mandatory = $false)]
        [string]$Comment,
        
        [Parameter(Mandatory = $false)]
        [string]$HostName,
        
        [Parameter(Mandatory = $false)]
        [string]$Domain,
        
        [Parameter(Mandatory = $false)]
        [string]$PrimaryMAC,
        
        [Parameter(Mandatory = $false)]
        [string]$PrimaryIP,
        
        [Parameter(Mandatory = $false)]
        [string]$PrimarySubnetMask,
        
        [Parameter(Mandatory = $false)]
        [string]$RegisteredUser,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("UseNextLogonUser", "DoNotUseRegisteredUser", "UpdateContinously", "EnterManually")]
        [string]$RegisteredUserUpdateMode,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("Always", "Never", "ForRegisteredUser")]
        [string]$UserRelatedJobExecution,
        
        [Parameter(Mandatory = $false)]
        [bool]$IsEnergyManagementActive,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("LAN", "Internet", "Dynamic")]
        [string]$NetworkMode,
        
        [Parameter(Mandatory = $false)]
        [bool]$ExtendedInternetMode,
        
        [Parameter(Mandatory = $false)]
        [string]$UUID
    )
    
    # Validate LogicalGroupId if provided
    if ($LogicalGroupId -and -not (Test-Guid -Guid $LogicalGroupId)) {
        Write-Error "Invalid LogicalGroupId format. The ID must be a valid GUID."
        return
    }
    
    # Build the request body
    $body = @{
        displayName = $DisplayName
    }
    
    if ($LogicalGroupId) {
        $body["logicalGroupId"] = $LogicalGroupId
    }
    
    if ($Comment) {
        $body["comment"] = $Comment
    }
    
    if ($HostName) {
        $body["hostName"] = $HostName
    }
    
    if ($Domain) {
        $body["domain"] = $Domain
    }
    
    if ($PrimaryMAC) {
        $body["primaryMAC"] = $PrimaryMAC
    }
    
    if ($PrimaryIP) {
        $body["primaryIP"] = $PrimaryIP
    }
    
    if ($PrimarySubnetMask) {
        $body["primarySubnetMask"] = $PrimarySubnetMask
    }
    
    if ($RegisteredUser) {
        $body["registeredUser"] = $RegisteredUser
    }
    
    if ($RegisteredUserUpdateMode) {
        $body["registeredUserUpdateMode"] = $RegisteredUserUpdateMode
    }
    
    if ($UserRelatedJobExecution) {
        $body["userRelatedJobExecution"] = $UserRelatedJobExecution
    }
    
    if ($PSBoundParameters.ContainsKey('IsEnergyManagementActive')) {
        $body["isEnergyManagementActive"] = $IsEnergyManagementActive
    }
    
    # Add clientAgentLink if NetworkMode or ExtendedInternetMode is specified
    if ($NetworkMode -or $PSBoundParameters.ContainsKey('ExtendedInternetMode')) {
        $clientAgentLink = @{}
        
        if ($NetworkMode) {
            $clientAgentLink["networkMode"] = $NetworkMode
        }
        
        if ($PSBoundParameters.ContainsKey('ExtendedInternetMode')) {
            $clientAgentLink["extendedInternetMode"] = $ExtendedInternetMode
        }
        
        $body["clientAgentLink"] = $clientAgentLink
    }
    
    if ($UUID) {
        $body["uuid"] = $UUID
    }
    
    # Make the API call
    try {
        $response = Invoke-bconnectV2Post -Endpoint "/endpoints/v2.0/WindowsEndpoints" -Body $body
        
        # Return the created endpoint
        return $response
    }
    catch {
        Write-Error "Failed to create Windows endpoint: $_"
        throw $_
    }
}
