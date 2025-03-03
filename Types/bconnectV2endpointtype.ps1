# Enum for Endpoint types
Add-Type -TypeDefinition @"
public enum bconnectV2EndpointType
{
    WindowsEndpoint = 1,
    AndroidEndpoint = 2,
    IOSEndpoint = 3,
    MacEndpoint = 4,
    NetworkEndpoint = 16,
    IndustrialEndpoint = 17
}
"@
