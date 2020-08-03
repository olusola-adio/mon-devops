Push-Location -Path $PSScriptRoot\..\..\PSScripts\

Describe "Import-ApimSwaggerApiDefinition unit tests" -Tag "Unit" {

    BeforeAll {  
        Mock New-AzureRmApiManagementContext -MockWith { return @{} }
        Mock Invoke-RestMethod
        Mock Set-Content
        Mock Get-AzureRmApiManagementApi { [PsCustomObject]
            @{
                ApiId = "bar"
                Path = "bar"
            }
        }
        Mock Import-AzureRmApiManagementApi
    }

    It "Should run with AzureRM cmdlets if a URL is supplied but not create a file" {

        $CmdletParameters = @{
           ApimResourceGroup = "mon-foo-bar-rg"
           InstanceName = "mon-foo-bar-apim"
           ApiName = "bar"
           SwaggerSpecificationUrl = "https://mon-foo-bar-fa.azurewebsites.net/api/bar/bar-api-definition"
       }

       .\..\..\PSScripts\Import-ApimSwaggerApiDefinition @CmdletParameters

        Should -Invoke Invoke-RestMethod -Exactly 0 -Scope It
        Should -Invoke Set-Content -Exactly 0 -Scope It
        Should -Invoke Get-AzureRmApiManagementApi -Exactly 1 -Scope It
        Should -Invoke Import-AzureRmApiManagementApi -Exactly 1 -Scope It

    }

    # Unable to test Az cmdlets alongside AzureRm.  After ZDT deployments are implemented across all projects this script will no longer require the AzureRm code blocks
    It "Should run with AZ cmdlets if a URL is supplied and UseAzModule is set to `$true but not create a file" -Skip {

        Mock Invoke-RestMethod
        Mock Set-Content
        Mock Get-AzApiManagementApi { [PsCustomObject]
            @{
                ApiId = "bar"
                Path = "bar"
            }
        }
        Mock Import-AzApiManagementApi

        $CmdletParameters = @{
           ApimResourceGroup = "mon-foo-bar-rg"
           InstanceName = "mon-foo-bar-apim"
           ApiName = "bar"
           SwaggerSpecificationUrl = "https://mon-foo-bar-fa.azurewebsites.net/api/bar/bar-api-definition"
           UseAzModule = $true
       }

       .\..\..\PSScripts\Import-ApimSwaggerApiDefinition @CmdletParameters

        Should -Invoke  Invoke-RestMethod -Exactly 0 -Scope It
        Should -Invoke  Set-Content -Exactly 0 -Scope It
        Should -Invoke  Get-AzApiManagementApi -Exactly 1 -Scope It
        Should -Invoke  Import-AzApiManagementApi -Exactly 1 -Scope It

    }

}

Push-Location -Path $PSScriptRoot