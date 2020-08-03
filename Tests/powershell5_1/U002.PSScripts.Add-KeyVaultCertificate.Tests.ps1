Push-Location -Path $PSScriptRoot\..\..\PSScripts\

Describe "Add-KeyVaultCertificate unit tests" -Tag "Unit" {

    BeforeAll {
        Mock Set-AzureKeyVaultSecret
    }
    It "Should open a pfx file and understand the contents" {

        $kvname   = "mon-foo-kv"
        $secname  = "foocert"
        $certdate = Get-Date "25 January 2020 11:51:04"

        .\..\..\PSScripts\Add-KeyVaultCertificate -keyVaultName $kvname -secretName $secname -pfxFilePath "$PSScriptRoot\testcert.pfx" -pfxPassword 'myPa$$w0rd'

        Should -Invoke Set-AzureKeyVaultSecret -Exactly 1 -ParameterFilter { $VaultName -eq $kvname -and $Name -eq $secname -and $ContentType -eq 'application/x-pkcs12' -and $Expires -eq $certdate } -Scope It
    }

}

Push-Location -Path $PSScriptRoot