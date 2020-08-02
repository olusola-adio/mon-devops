<#
.SYNOPSIS
Test runner for ARM acceptance tests

.DESCRIPTION
Test runner for ARM acceptance tests

.EXAMPLE
Invoke-AcceptanceTests.ps1

.EXAMPLE
Invoke-AcceptanceTests.ps1


#>

[CmdletBinding()]

$TestParameters = @{
    OutputFormat = 'NUnitXml'
    OutputFile   = "$PSScriptRoot\TEST-Acceptance.xml"
    Script       = "$PSScriptRoot\arm"
    PassThru     = $True
    Tag          = "Acceptance"
}


# Install-Module -Name Pester -RequiredVersion 4.10.1 -Force -SkipPublisherCheck

# Import-Module -Name Pester -Scope Global

# $pesterModules = @( Get-Module -Name "Pester" -ErrorAction "SilentlyContinue" );
# if( ($null -eq $pesterModules) -or ($pesterModules.Length -eq 0) )
# {
#     throw "no pester module loaded!";
# }
# if( $pesterModules.Length -gt 1 )
# {
#     throw "multiple pester modules loaded!";
# }
# if( $pesterModules[0].Version -ne ([version] "4.10.1") )
# {
#     throw "unsupported pester version '$($pesterModules[0].Version)'";
# }

# Invoke tests
$Result = Invoke-Pester -Tag "Acceptance" -Path "$PSScriptRoot\arm" 

# report failures
if ($Result.FailedCount -ne 0) { 
    Write-Error "Pester returned $($result.FailedCount) errors"
}