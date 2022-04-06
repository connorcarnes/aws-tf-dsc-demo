# https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-state-manager-using-mof-file.html
# https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-associations.html
# https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2-windows-volumes.html
configuration corp_domain {
    param
    (
        [Parameter(Mandatory)]
        [pscredential]$safemodeAdministratorCred,
        [Parameter(Mandatory)]
        [pscredential]$domainCred
    )

    Import-DscResource -ModuleName ActiveDirectoryDsc
    Import-DscResource -ModuleName NetworkingDsc
    Import-DscResource -ModuleName ComputerManagementDsc
    Import-DscResource -ModuleName StorageDsc

    Node $AllNodes.NodeName {
        FirewallProfile DisablePublic {
            Enabled = "False"
            Name    = "Public"
        }

        FirewallProfile DisablePrivate {
            Enabled = "False"
            Name    = "Private"
        }

        FirewallProfile DisableDomain {
            Enabled = "False"
            Name    = "Domain"
        }

        NetAdapterBinding DisableIPv6 {
            InterfaceAlias = 'Ethernet 2'
            ComponentId    = 'ms_tcpip6'
            State          = 'Disabled'
        }
    }

    Node "dc00" {
        WindowsFeature ADDSInstall {
            Ensure = "Present"
            Name   = "AD-Domain-Services"
        }

        WindowsFeature ADDSTools {
            Ensure = "Present"
            Name   = "RSAT-ADDS"
        }

        User AdminUser {
            Ensure   = "Present"
            UserName = $domainCred.UserName
            Password = $domainCred
        }

        Group Administrators {
            GroupName        = "Administrators"
            MembersToInclude = $domainCred.UserName
            DependsOn        = "[User]AdminUser"
        }

        ADDomain CreateDC {
            DomainName                    = $ConfigurationData.corp_domain.name
            Credential                    = $domainCred
            SafemodeAdministratorPassword = $safemodeAdministratorCred
            DatabasePath                  = 'C:\NTDS'
            LogPath                       = 'C:\NTDS'
            DependsOn                     = "[WindowsFeature]ADDSInstall"
        }

        WaitForADDomain waitFirstDomain {
            DomainName = $ConfigurationData.corp_domain.name
            DependsOn  = "[ADDomain]CreateDC"
        }

        #DnsServerAddress DnsServerAddress {
        #    Address        = '127.0.0.1', '1.1.1.1'
        #    InterfaceAlias = 'Ethernet 2'
        #    AddressFamily  = 'IPv4'
        #    Validate       = $false
        #    DependsOn      = "[WaitForADDomain]waitFirstDomain"
        #}

        ADUser 'regular.user' {
            Ensure     = 'Present'
            UserName   = 'regular.user'
            Password   = (New-Object System.Management.Automation.PSCredential("regular.user", (ConvertTo-SecureString "this_gets_ignored" -AsPlainText -Force)))
            DomainName = 'first.local'
            Path       = 'CN=Users,DC=first,DC=local'
            DependsOn  = "[WaitForADDomain]waitFirstDomain"
        }
    }
    Node "app00" {
        #DnsServerAddress DnsServerAddress {
        #    Address        = $ConfigurationData.corp_domain.dc00_ip, '1.1.1.1'
        #    InterfaceAlias = 'Ethernet 2'
        #    AddressFamily  = 'IPv4'
        #    Validate       = $false
        #    DependsOn      = "[WaitForADDomain]waitFirstDomain"
        #}

        WaitForADDomain 'WaitForADDomain' {
            DomainName              = $ConfigurationData.corp_domain.name
            Credential              = $domainCred
            WaitForValidCredentials = $true
            RestartCount            = 5
            WaitForValidCredentials = $true
        }

        Computer app00 {
            Name       = 'app00'
            DomainName = $ConfigurationData.corp_domain.name
            Credential = $domainCred
            Server     = 'dc00'
            DependsOn  = "[WaitForADDomain]WaitForADDomain"
        }

        WaitForDisk data_disk_wait
        {
             DiskIdType       = 'Location'
             DiskId           = 'Integrated : Adapter 2 : Port 0 : Target 5 : LUN 0'
             RetryIntervalSec = 60
             RetryCount       = 60
        }

        Disk data_disk
        {
            DiskIdType  = 'Location'
            DiskId      = 'Integrated : Adapter 2 : Port 0 : Target 5 : LUN 0'
            DriveLetter = 'D'
            DependsOn   = '[WaitForDisk]data_disk_wait'
        }
    }
}

$ConfigData = @{
    AllNodes = @(
        @{
            Nodename                    = "dc00"
            Description                 = "PDC for corp.local"
            RetryCount                  = 1
            RetryIntervalSec            = 1
            PsDscAllowPlainTextPassword = $true
        },
        @{
            Nodename                    = "app00"
            Description                 = "generic app server"
            RetryCount                  = 1
            RetryIntervalSec            = 1
            PsDscAllowPlainTextPassword = $true
        }
    )
    corp_domain = @{
        name    = "corp.local"
        dc00_ip = "10.0.1.10"
    }
}

corp_domain -ConfigurationData $ConfigData `
    -domainCred (New-Object System.Management.Automation.PSCredential("admin", (ConvertTo-SecureString "this_gets_ignored" -AsPlainText -Force))) `
    -safemodeAdministratorCred (New-Object System.Management.Automation.PSCredential("admin", (ConvertTo-SecureString "this_gets_ignored" -AsPlainText -Force)))
