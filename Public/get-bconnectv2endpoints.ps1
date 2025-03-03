function Get-bconnectV2Endpoints {
    <#
    .SYNOPSIS
        Gets all endpoints from the bconnectV2 API
    
    .DESCRIPTION
        Gets all endpoints from the bconnectV2 API with optional filtering
    
    .PARAMETER OrderBy
        Sorts results by property name and with sort direction
        
    .PARAMETER SearchQuery
        Filters results by matching the given value against searchable properties
        
    .PARAMETER DisplayName
        Filters result by matching the exact value against DisplayName
        
    .PARAMETER HostName
        Filters result by matching the exact value against HostName
        
    .PARAMETER Page
        The zero-indexed number of the first page to return
        
    .PARAMETER PageSize
        The number of items to list on a single page (default: 1000, max: 1000)
        
    .EXAMPLE
        Get-bconnectV2Endpoints
        
    .EXAMPLE
        Get-bconnectV2Endpoints -SearchQuery "Windows" -PageSize 50
        
    .EXAMPLE
        Get-bconnectV2Endpoints -OrderBy "DisplayName asc" -DisplayName "Server01"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$OrderBy,
        
        [Parameter(Mandatory = $false)]
        [string]$SearchQuery,
        
        [Parameter(Mandatory = $false)]
        [string]$DisplayName,
        
        [Parameter(Mandatory = $false)]
        [string]$HostName,
        
        [Parameter(Mandatory = $false)]
        [int]$Page,
        
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 1000)]
        [int]$PageSize = 1000
    )
    
    # Build query parameters
    $queryParams = @{}
    
    if ($OrderBy) {
        $queryParams["OrderBy"] = $OrderBy
    }
    
    if ($SearchQuery) {
        $queryParams["SearchQuery"] = $SearchQuery
    }
    
    if ($DisplayName) {
        $queryParams["DisplayName"] = $DisplayName
    }
    
    if ($HostName) {
        $queryParams["HostName"] = $HostName
    }
    
    if ($PSBoundParameters.ContainsKey('Page')) {
        $queryParams["Page"] = $Page
    }
    
    $queryParams["PageSize"] = $PageSize
    
    # Make the API call
    try {
        $response = Invoke-bconnectV2Get -Endpoint "/endpoints/v2.0/Endpoints" -QueryParameters $queryParams
        
        # Return the data portion of the paged list
        return $response.data
    }
    catch {
        Write-Error "Failed to get endpoints: $_"
        throw $_
    }
}
