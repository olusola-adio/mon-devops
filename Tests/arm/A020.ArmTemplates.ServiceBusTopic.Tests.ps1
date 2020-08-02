# common variables
$ResourceGroupName = "mon-test-template-rg"
$TemplateFile = "$PSScriptRoot\..\..\ArmTemplates\ServiceBus\servicebus-topic.json"

Describe "Service Bus Topic Deployment Tests" -Tag "Acceptance" {
  
  Context "When deploying the Service Bus Topic" {
    $TemplateParameters = @{
      serviceBusNamespaceName = "mon-foo-bar-ns"
      serviceBusTopicName     = "topic-name"
      messageDefaultTTL       = "P90D"
      topicMaxSizeMb          = 1024
    }
    $TestTemplateParams = @{
      ResourceGroupName       = $ResourceGroupName
      TemplateFile            = $TemplateFile
      TemplateParameterObject = $TemplateParameters
    }
  
    It "Should be deployed successfully" {
      $output = Test-AzureRmResourceGroupDeployment @TestTemplateParams
      $output | Should -Be $null
    }

    if ($output) {
      Write-Error $output.Message
    }

  }
}