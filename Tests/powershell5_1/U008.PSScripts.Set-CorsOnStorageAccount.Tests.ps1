Push-Location -Path $PSScriptRoot\..\..\PSScripts\

Describe "Set-CorsOnStorageAccount unit tests" -Tag "Unit" {

    BeforeAll {  
        Mock New-AzureStorageContext
        Mock Get-AzureStorageCORSRule
        Mock Set-AzureStorageCORSRule
    }

    It "Should call the Azure cmdlets" {

        .\..\..\PSScripts\Set-CorsOnStorageAccount -StorageAccountName "monfoobarstr" -StorageAccountKey "foo=" -AllowedOrigins "foo.example.org"

        Should -Invoke  New-AzureStorageContext -Exactly 1 -ParameterFilter { $StorageAccountName -eq "monfoobarstr" -and $StorageAccountKey -eq "foo=" } -Scope It
        Should -Invoke  Get-AzureStorageCORSRule -Exactly 1
        Should -Invoke  Set-AzureStorageCORSRule -Exactly 1
    }

}

Push-Location -Path $PSScriptRoot