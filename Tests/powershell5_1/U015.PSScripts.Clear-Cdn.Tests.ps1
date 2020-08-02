Push-Location -Path $PSScriptRoot\..\..\PSScripts\

# solves CommandNotFoundException
function Unpublish-AzureRmCdnEndpointContent {}

Describe "Clear-Cdn unit tests" -Tag "Unit" {

    Mock Unpublish-AzureRmCdnEndpointContent

    It "Should pass parameters to Unpublish-AzureRmCdnEndpointContent" {

        .\Clear-Cdn -ResourceGroupName mon-foo-bar-rg -CdnName mon-foo-bar-cdn -EndpointName mon-foo-bar-assets

        Assert-MockCalled Unpublish-AzureRmCdnEndpointContent

    }

}

Push-Location -Path $PSScriptRoot