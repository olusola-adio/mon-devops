Push-Location -Path $PSScriptRoot\..\..\PSScripts\

Describe "New-KeyVault unit tests" -Tag "Unit" {

    Mock Get-AzureRmResourceGroup { return ConvertFrom-Json '{ "ResourceGroupName": "mon-foobar-rg", "Location": "northeurope" }' }
    Mock New-AzureRmKeyVault { return ConvertFrom-Json '{ "VaultName": "mon-foobar-kv", "AccessPolicies": [ { "ObjectId": "12345678-abcd-1234-5678-1234567890ab" } ] }' }
    Mock Remove-AzureRmKeyVaultAccessPolicy

    $kvname = "mon-foobar-kv"
    $rgname = "mon-foobar-rg"

    It "Should create a key vault if one does not exist" {
        Mock Get-AzureRmKeyVault { return $null }

        .\..\..\PSScripts\New-KeyVault -keyVaultName $kvname -ResourceGroupName $rgname

        Should -Invoke Get-AzureRmKeyVault -Exactly 1 -Scope It
        Should -Invoke Get-AzureRmResourceGroup -Exactly 1 -Scope It
        Should -Invoke New-AzureRmKeyVault -Exactly 1 -Scope It
        Should -Invoke Remove-AzureRmKeyVaultAccessPolicy -Exactly 1 -Scope It
    }

    It "Should not create anything if the key vault already exist" {
        Mock Get-AzureRmKeyVault { return ConvertFrom-Json '{ "VaultName": "mon-foobar-kv", "ResourceGroupName": "mon-foobar-rg", "Location": "northeurope" }' }

        .\..\..\PSScripts\New-KeyVault -keyVaultName $kvname -ResourceGroupName $rgname

        Should -Invoke Get-AzureRmKeyVault -Exactly 1 -Scope It
        Should -Invoke Get-AzureRmResourceGroup -Exactly 0 -Scope It
        Should -Invoke New-AzureRmKeyVault -Exactly 0 -Scope It
        Should -Invoke Remove-AzureRmKeyVaultAccessPolicy -Exactly 0 -Scope It
    }

}

Push-Location -Path $PSScriptRoot