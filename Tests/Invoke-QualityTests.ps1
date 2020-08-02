<#
.SYNOPSIS
Test runner for code quality tests

.DESCRIPTION
Test runner for code quality tests

.EXAMPLE
Invoke-QualityTests.ps1

.EXAMPLE
Invoke-QualityTests.ps1

#>

[CmdletBinding()]
param()


# Install-Module -Name Pester -RequiredVersion 4.10.1 -Force -SkipPublisherCheck

# Import-Module -Name Pester -Scope Local

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

$TestParameters = @{
    OutputFormat = 'NUnitXml'
    OutputFile   = "$PSScriptRoot\TEST-Quality.xml"
    Script       = "$PSScriptRoot\Quality"
    PassThru     = $True
    Tag          = "Quality"
}

# Invoke tests
#$Result = Invoke-Pester @TestParameters



$Result = Invoke-Pester -Script "$PSScriptRoot\Quality" -PassThru -Verbose -OutputFile "$PSScriptRoot\TEST-Quality.xml" -OutputFormat NUnitXml -Show All

# report failures
if ($Result.FailedCount -ne 0) { 
    Write-Error "Pester returned $($result.FailedCount) errors"
}