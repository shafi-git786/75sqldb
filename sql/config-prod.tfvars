resource_group_name = "rg-seventy5-prod11-eastus2"
location            = "eastus2"
environment         = "prod"
subscription_id     = "460a7c49-dc6c-40b3-9a69-d9327b876486"
# SQL Server
sql_server_name                           = "sql-seventy5-eus2n0p"
sql_server_admin_login_name               = "edsdba"
enable_azuread_administrator              = true
sql_server_aad_admin_login_name           = "gAZ10654-sql-seventy5-eus2n0p-sa"
active_directory_admin_object_id          = "41adc884-7eac-49bc-b149-5dd3b4fa464c"
deploy_sql_server_log_analytics_workspace = false
log_analytics_name                        = ""
deploy_sql_server_key_vault               = true
key_vault_name                            = "kv-75-prod-eastus2"
enable_sql_server_delete_lock             = false
public_network_access_enabled             = true
firewall_rules = [
  {
    name     = "Kroger-Public-IPs",
    start_ip = "158.48.0.0",
    end_ip   = "158.48.255.255"
  },
  {
    name     = "AKS Node Ips",
    start_ip = "172.24.0.0",
    end_ip   = "172.24.255.255"
  },
  {
    name     = "AKS DNS Ips",
    start_ip = "172.23.0.0",
    end_ip   = "172.23.255.255"
  }
]
mandatory_tags = {
  owner               = "robert.carlson@kroger.com"
  cost-center         = "2015-6025040"
  application-name    = "seventy5"
  environment         = "prod"
  spm-id              = "4064"
  lob                 = "store assoc tech"
  data-classification = "Internal"
}
# SQL Single Database
deploy_sql_single_database                   = true
deploy_sql_single_database_metrics_dashboard = false
single_database_name                         = "sqldb-seventy5db-p"
single_database_sku_name                     = "GP_S_Gen5_2"
serverless                                   = true
single_database_min_capacity                 = 1
single_database_auto_pause_delay_in_minutes  = -1 # -1 is disabled the auto pause
single_database_max_size_gb                  = 32
single_database_zone_redundant               = true
single_database_storage_account_type         = "Geo"
single_database_backup_retention_days        = 30
single_database_geo_backup_enabled           = true
enable_single_database_short_term_retention  = true
enable_single_database_long_term_retention   = true
single_database_read_replica_count           = 0
single_database_enable_autotune              = false
single_database_enable_maintenance_config    = false
enable_single_database_delete_lock           = false
single_database_read_scale                   = false
action_group_name                            = "sqldb-seventy5db-p-action-group"
action_group_alerts_email_id                 = "dbasqlcorp@kroger.com"

federated_identity_credential_name = "seventy5-federated-prod"
issuer                             = "https://eastus2.oic.prod-aks.azure.com/8331e14a-9134-4288-bf5a-5e2c8412f074/7fc56d43-fa3e-455e-be51-24ab6a200541/"
namespace                          = "seventy5-prod"
serviceaccount                     = "id-seventy5-prod-eastus2"

# https://confluence.kroger.com/confluence/pages/viewpage.action?pageId=183483784
sql_private_endpoints = {

  # PE for access to Prod East US 2 (required for on-prem access)
  "sql-seventy5-prod-eastus2-prod-eastus2-prvendpt" = {
    subnet_location            = "eastus2"
    private_endpoint_subnet_id = "/subscriptions/460a7c49-dc6c-40b3-9a69-d9327b876486/resourceGroups/networking-eastus2/providers/Microsoft.Network/virtualNetworks/private-endpoint-01-for-prod-eastus2-vnet/subnets/private-endpoint"
    private_dns_zone_id        = "/subscriptions/2912a3d7-4fae-4252-9f75-670d4c28b63a/resourceGroups/rg-private-endpoint-dns-eastus2/providers/Microsoft.Network/privateDnsZones/privatelink.database.windows.net"
  },
  # PE for access to Prod Central US
  "sql-seventy5-prod-eastus2-prod-centralus-prvendpt" = {
    subnet_location            = "centralus"
    private_endpoint_subnet_id = "/subscriptions/460a7c49-dc6c-40b3-9a69-d9327b876486/resourceGroups/networking-centralus/providers/Microsoft.Network/virtualNetworks/private-endpoint-01-for-prod-centralus-vnet/subnets/private-endpoint"
    private_dns_zone_id        = "/subscriptions/2912a3d7-4fae-4252-9f75-670d4c28b63a/resourceGroups/rg-private-endpoint-dns-centralus/providers/Microsoft.Network/privateDnsZones/privatelink.database.windows.net"
  }
}

cluster_name = "aks-sat-shared-prod-eastus2"
