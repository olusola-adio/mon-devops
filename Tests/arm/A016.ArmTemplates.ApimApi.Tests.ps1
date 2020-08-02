# common variables
$ResourceGroupName = "mon-test-template-rg"
$TemplateFile = "$PSScriptRoot\..\..\ArmTemplates\APIM\apim-api.json"

Describe "Apim Service Deployment Tests" -Tag "Acceptance" {
  
    Context "When APIM api is deployed with just name, product and api name" {
        $TemplateParameters = @{
            apimProductInstanceName = "product-bar-foo"
            apimServiceName         = "mon-foo-bar-apim"
            apiName                 = "foo"
        }
        $TestTemplateParams = @{
            ResourceGroupName       = $ResourceGroupName
            TemplateFile            = $TemplateFile
            TemplateParameterObject = $TemplateParameters
        }

        $output = Test-AzureRmResourceGroupDeployment @TestTemplateParams
  
        It "Should be deployed successfully" {
            $output | Should -Be $null
        }

    }

}