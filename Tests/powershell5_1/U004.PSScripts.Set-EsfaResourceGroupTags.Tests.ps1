Push-Location -Path $PSScriptRoot\..\..\PSScripts\

Describe "Set-EsfaResourceGroupTags unit tests" -Tag "Unit" {

    Mock Get-AzureRmResourceGroup { [PsCustomObject]
        @{
            ResourceGroupName = "mon-foobar-rg"
            Location = "uksouth"
            Tags = @{"Parent Business" =  "Logion Limited"; "Service Offering" = "Digital First Career Service (MONS) Website"; "Environment" = "Dev/Test"} 
        }
    }
    Mock New-AzureRmResourceGroup
    Mock Set-AzureRmResourceGroup

    It "Should do nothing if a resource group exists with matching tags" {

        .\..\..\PSScripts\Set-EsfaResourceGroupTags -ResourceGroupName "mon-foobar-rg" -Environment "Dev/Test" -ParentBusiness "Logion Limited" -ServiceOffering "Digital First Career Service (MONS) Website"

        Assert-MockCalled Get-AzureRmResourceGroup -Exactly 1 -Scope It
        Assert-MockCalled New-AzureRmResourceGroup -Exactly 0 -Scope It
        Assert-MockCalled Set-AzureRmResourceGroup -Exactly 0 -Scope It

    }

    It "Should update existing resource group if group exists with different tags" {

        .\..\..\PSScripts\Set-EsfaResourceGroupTags -ResourceGroupName "mon-foobar-rg" -Environment "Dev/Test" -ParentBusiness "Logion Limited" -ServiceOffering "Digital First Career Service (MONS) Website (PP)"

        Assert-MockCalled Get-AzureRmResourceGroup -Exactly 1 -Scope It
        Assert-MockCalled New-AzureRmResourceGroup -Exactly 0 -Scope It
        Assert-MockCalled Set-AzureRmResourceGroup -Exactly 1 -Scope It

    }

    It "Should create new resource group if group doesn't exists" {

        Mock Get-AzureRmResourceGroup

        .\..\..\PSScripts\Set-EsfaResourceGroupTags -ResourceGroupName "mon-barfoo-rg" -Environment "Dev/Test" -ParentBusiness "Logion Limited" -ServiceOffering "Digital First Career Service (MONS) Website (PP)"

        Assert-MockCalled Get-AzureRmResourceGroup -Exactly 1 -Scope It
        Assert-MockCalled New-AzureRmResourceGroup -Exactly 1 -Scope It
        Assert-MockCalled Set-AzureRmResourceGroup -Exactly 0 -Scope It

    }

    It "Should add tags to the group it not tags exist" {

        Mock Get-AzureRmResourceGroup { [PsCustomObject]
            @{
                ResourceGroupName = "mon-foobar-rg"
                Location = "northeurope"
            }
        }
    
        .\..\..\PSScripts\Set-EsfaResourceGroupTags -ResourceGroupName "mon-barfoo-rg" -Environment "Dev/Test" -ParentBusiness "Logion Limited" -ServiceOffering "Digital First Career Service (MONS) Website (PP)"

        Assert-MockCalled Get-AzureRmResourceGroup -Exactly 1 -Scope It
        Assert-MockCalled New-AzureRmResourceGroup -Exactly 0 -Scope It
        Assert-MockCalled Set-AzureRmResourceGroup -Exactly 1 -Scope It

    }

}

Push-Location -Path $PSScriptRoot