function Edit-bconnectV2WindowsEndpoint {
    <#
    .SYNOPSIS
        Edits a Windows endpoint in the bconnectV2 API
    
    .DESCRIPTION
        Edits a Windows endpoint in the bconnectV2 API using JSON Patch operations
    
    .PARAMETER Id
        The ID of the Windows endpoint to edit
        
    .PARAMETER DisplayName
        The new display name of the endpoint
        
    .PARAMETER LogicalGroupId
        The new ID of the logical group to assign the endpoint to
        
    .PARAMETER Comment
        The new comment to add to the endpoint
        
    .PARAMETER HostName
        The new hostname of the endpoint
        
    .PARAMETER Domain
        The new domain of the endpoint
        
    .PARAMETER PrimaryMAC
        The new primary MAC address of the endpoint
        
    .PARAMETER PrimaryIP
        The new primary IP address of the endpoint
        
    .PARAMETER PrimarySubnetMask
        The new primary subnet mask of the endpoint
        
    .PARAMETER RegisteredUser
        The new registered user of the endpoint
        
    .PARAMETER RegisteredUserUpdateMode
        The new registered user update mode (UseNextLogonUser, DoNotUseRegisteredUser, UpdateContinously, EnterManually)
        
    .PARAMETER UserRelatedJobExecution
        The new user related job execution mode (Always, Never, ForRegisteredUser)
        
    .PARAMETER IsEnergyManagementActive
        Whether energy management is active for the endpoint
        
    .PARAMETER IsDeactivated
        Whether the endpoint is deactivated
        
    .PARAMETER NetworkMode
        The new network mode for the client agent (LAN, Internet, Dynamic)
        
    .PARAMETER ExtendedInternetMode
        Whether extended internet mode is enabled for the client agent
        
    .PARAMETER CustomStateType
        The new custom state type for the endpoint
        
    .PARAMETER CustomStateText
        The new custom state text for the endpoint
        
    .PARAMETER UUID
        The new UUID of the endpoint
        
    .EXAMPLE
        Edit-bconnectV2WindowsEndpoint -Id "12345678-1234-1234-1234-123456789012" -DisplayName "NewServerName" -Comment "Updated server"
        
    .EXAMPLE
        Get-bconnectV2WindowsEndpoint -Id "12345678-1234-1234-1234-123456789012" | Edit-bconnectV2WindowsEndpoint -IsDeactivated $true
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("EndpointId")]
        [string]$Id,
        
        [Parameter(Mandatory = $false)]
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
        [bool]$IsDeactivated,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("LAN", "Internet", "Dynamic")]
        [string]$NetworkMode,
        
        [Parameter(Mandatory = $false)]
        [bool]$ExtendedInternetMode,
        
        [Parameter(Mandatory = $false)]
        [int]$CustomStateType,
        
        [Parameter(Mandatory = $false)]
        [string]$CustomStateText,
        
        [Parameter(Mandatory = $false)]
        [string]$UUID
    )
    
    process {
        # Validate the ID is a valid GUID
        if (-not (Test-Guid -Guid $Id)) {
            Write-Error "Invalid endpoint ID format. ID must be a valid GUID."
            return
        }
        
        # Validate LogicalGroupId if provided
        if ($LogicalGroupId -and -not (Test-Guid -Guid $LogicalGroupId)) {
            Write-Error "Invalid LogicalGroupId format. The ID must be a valid GUID."
            return
        }
        
        # Build the patch operations array
        $patchOperations = @()
        
        # Add all specified parameters as patch operations
        if ($DisplayName) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/displayName"
                "value" = $DisplayName
            }
        }
        
        if ($LogicalGroupId) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/logicalGroupId"
                "value" = $LogicalGroupId
            }
        }
        
        if ($PSBoundParameters.ContainsKey('Comment')) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/comment"
                "value" = $Comment
            }
        }
        
        if ($HostName) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/hostName"
                "value" = $HostName
            }
        }
        
        if ($Domain) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/domain"
                "value" = $Domain
            }
        }
        
        if ($PrimaryMAC) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/primaryMAC"
                "value" = $PrimaryMAC
            }
        }
        
        if ($PrimaryIP) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/primaryIP"
                "value" = $PrimaryIP
            }
        }
        
        if ($PrimarySubnetMask) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/primarySubnetMask"
                "value" = $PrimarySubnetMask
            }
        }
        
        if ($RegisteredUser) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/registeredUser"
                "value" = $RegisteredUser
            }
        }
        
        if ($RegisteredUserUpdateMode) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/registeredUserUpdateMode"
                "value" = $RegisteredUserUpdateMode
            }
        }
        
        if ($UserRelatedJobExecution) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/userRelatedJobExecution"
                "value" = $UserRelatedJobExecution
            }
        }
        
        if ($PSBoundParameters.ContainsKey('IsEnergyManagementActive')) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/isEnergyManagementActive"
                "value" = $IsEnergyManagementActive
            }
        }
        
        if ($PSBoundParameters.ContainsKey('IsDeactivated')) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/isDeactivated"
                "value" = $IsDeactivated
            }
        }
        
        # Handle NetworkMode and ExtendedInternetMode which are under clientAgentLink
        if ($NetworkMode) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/clientAgentLink/NetworkMode"
                "value" = $NetworkMode
            }
        }
        
        if ($PSBoundParameters.ContainsKey('ExtendedInternetMode')) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/clientAgentLink/ExtendedInternetMode"
                "value" = $ExtendedInternetMode
            }
        }
        
        # Handle CustomStateType and CustomStateText which are under customState
        if ($PSBoundParameters.ContainsKey('CustomStateType')) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/customState/Type"
                "value" = $CustomStateType
            }
        }
        
        if ($PSBoundParameters.ContainsKey('CustomStateText')) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/customState/Text"
                "value" = $CustomStateText
            }
        }
        
        if ($UUID) {
            $patchOperations += @{
                "op" = "replace"
                "path" = "/UUID"
                "value" = $UUID
            }
        }
        
        # If no patch operations were specified, return early
        if ($patchOperations.Count -eq 0) {
            Write-Warning "No properties were specified to update. The endpoint was not modified."
            return
        }
        
        # Make the API call
        try {
            $response = Invoke-bconnectV2Patch -Endpoint "/endpoints/v2.0/WindowsEndpoints/$Id" -Body $patchOperations
            
            # Return the updated endpoint
            return $response
        }
        catch {
            Write-Error "Failed to update Windows endpoint with ID '$Id': $_"
            throw $_
        }
    }
}
