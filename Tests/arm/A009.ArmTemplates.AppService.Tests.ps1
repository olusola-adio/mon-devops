# common variables
$ResourceGroupName = "mon-test-template-rg"
$TemplateFile = "$PSScriptRoot\..\..\ArmTemplates\app-service.json"

Describe "App Service Deployment Tests" -Tag "Acceptance" {
  
  Context "When app service is deployed with just name and ASP" {
    $TemplateParameters = @{
      appServiceName     = "mon-foo-bar-as"
      appServicePlanName = "mon-test-template-asp"
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

  Context "When app service is deployed as a function app" {
    $TemplateParameters = @{
      appServiceName     = "mon-foo-bar-fa"
      appServicePlanName = "mon-test-template-asp"
      appServiceType     = "functionapp"
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