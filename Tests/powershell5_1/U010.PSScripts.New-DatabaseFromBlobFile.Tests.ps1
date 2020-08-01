Push-Location -Path $PSScriptRoot\..\..\PSScripts\

$params = @{
    ResourceGroupName = "mon-foo-bar-rg"
    SQLServerName     = "mon-foo-bar-sql"
    SQLDatabase       = "mon-foo-bar-db" 
    SQLAdminUsername  = "admin"
    SQLAdminPassword  = "not-a-real-password"
    StorageAccountKey = "not-a-real-key"
    StorageUrl        = "https://monfoobarstr.blob.core.windows.net/backup/db.bacpac"
}

# solves CommandNotFoundException
function New-AzureRmSqlDatabaseImport {}
function Get-AzureRmSqlDatabaseImportExportStatus {}
function Set-AzureRmSqlDatabase {}
function Get-AzureRmSqlDatabase {}

Describe "New-DatabaseFromBlobFile unit tests" -Tag "Unit" {

    Mock New-AzureRmSqlDatabaseImport { return ConvertFrom-Json '{ "OperationStatusLink": "https://management.azure.com/subscriptions/blah/guid?apiversion=1-2-3" }' }
    Mock Get-AzureRmSqlDatabaseImportExportStatus { return ConvertFrom-Json '{ "Status": "Succeeded", "StatusMessage": "" }' }
    Mock Set-AzureRmSqlDatabase
    Mock Get-AzureRmSqlDatabase

    It "Should create a database" {
        .\New-DatabaseFromBlobFile @params

        Assert-MockCalled New-AzureRmSqlDatabaseImport -Exactly 1 -Scope It
        Assert-MockCalled Get-AzureRmSqlDatabaseImportExportStatus -Exactly 1 -Scope It
        Assert-MockCalled Set-AzureRmSqlDatabase -Exactly 0 -Scope It
        Assert-MockCalled Get-AzureRmSqlDatabase -Exactly 1 -Scope It
    }

    It "Should add database to elastic pool if one is specified" {
        $params['ElasticPool'] = "mon-foo-bar-epl"

        .\New-DatabaseFromBlobFile @params

        Assert-MockCalled New-AzureRmSqlDatabaseImport -Exactly 1 -Scope It
        Assert-MockCalled Get-AzureRmSqlDatabaseImportExportStatus -Exactly 1 -Scope It
        Assert-MockCalled Set-AzureRmSqlDatabase -Exactly 1 -Scope It
        Assert-MockCalled Get-AzureRmSqlDatabase -Exactly 0 -Scope It
    }

}

Push-Location -Path $PSScriptRoot