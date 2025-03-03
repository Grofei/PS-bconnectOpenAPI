# Enum for Endpoint management state
Add-Type -TypeDefinition @"
public enum bconnectV2EndpointManagementState
{
    Unknown = 0,
    Enrollable = 1,
    Enrolling = 2,
    Managed = 3,
    Unmanaged = 4
}
"@
