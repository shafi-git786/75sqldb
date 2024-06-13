locals {
  tags = merge(var.mandatory_tags, var.additional_tags)
}

module "sql_server" {
  source                                    = "git::https://github.com/krogertechnology/daas-terraform-azurerm-sql-server.git//Terraform/modules/sql_server?ref=v0.2.1"
  resource_group_name                       = var.resource_group_name
  sql_server_version                        = var.sql_server_version
  minimum_tls_version                       = var.minimum_tls_version
  location                                  = var.location
  tenant_id                                 = var.tenant_id
  mandatory_tags                            = var.mandatory_tags
  additional_tags                           = var.additional_tags
  firewall_rules                            = var.firewall_rules
  sql_virtual_network_rules                 = var.sql_virtual_network_rules
  deploy_sql_server_key_vault               = var.deploy_sql_server_key_vault
  deploy_sql_server_log_analytics_workspace = var.deploy_sql_server_log_analytics_workspace
  sql_server_admin_login_name               = var.sql_server_admin_login_name
  sql_connection_policy                     = var.sql_connection_policy
  sql_server_aad_admin_login_name           = var.sql_server_aad_admin_login_name
  active_directory_admin_object_id          = var.active_directory_admin_object_id
  sql_server_name                           = var.sql_server_name
  enable_azuread_administrator              = var.enable_azuread_administrator
  log_analytics_name                        = var.log_analytics_name
  log_analytics_sku                         = var.log_analytics_sku
  log_analytics_retention                   = var.log_analytics_retention
  keyvault_ip_rules                         = var.keyvault_ip_rules
  kv_access_object_ids                      = var.kv_access_object_ids
  keyvault_subnet_ids                       = var.keyvault_subnet_ids
  key_vault_name                            = var.key_vault_name
  key_vault_sku                             = var.key_vault_sku
  key_vault_soft_delete_retention_days      = var.key_vault_soft_delete_retention_days
  enable_sql_server_delete_lock             = var.enable_sql_server_delete_lock
  public_network_access_enabled             = var.public_network_access_enabled
}

module "sql_single_database" {
  count                                        = (var.deploy_sql_single_database) ? 1 : 0
  source                                       = "git::https://github.com/krogertechnology/daas-terraform-azurerm-sql-server.git//Terraform/modules/sql_single_database?ref=v0.2.2"
  resource_group_name                          = var.resource_group_name
  location                                     = var.location
  subscription_id                              = var.subscription_id
  sql_server_admin_login_name                  = var.sql_server_admin_login_name
  sql_server_name                              = var.sql_server_name
  log_analytics_workspace_id                   = module.sql_server.log_analytics_workspace_id
  sql_server_password                          = module.sql_server.sql_server_password
  sql_server_id                                = module.sql_server.sql_server_id
  log                                          = var.log
  metric                                       = var.metric
  action_group_id                              = azurerm_monitor_action_group.action_group[0].id
  mandatory_tags                               = var.mandatory_tags
  database_collation                           = var.database_collation
  single_database_name                         = var.single_database_name
  single_database_sku_name                     = var.single_database_sku_name
  serverless                                   = var.serverless
  single_database_min_capacity                 = var.single_database_min_capacity
  single_database_auto_pause_delay_in_minutes  = var.single_database_auto_pause_delay_in_minutes
  single_database_max_size_gb                  = var.single_database_max_size_gb
  single_database_zone_redundant               = var.single_database_zone_redundant
  single_database_backup_retention_days        = var.single_database_backup_retention_days
  maintenance_config                           = var.maintenance_config
  deploy_sql_single_database_metrics_dashboard = var.deploy_sql_single_database_metrics_dashboard
  deploy_sql_server_log_analytics_workspace    = var.deploy_sql_server_log_analytics_workspace
  single_database_backup_interval_in_hours     = var.single_database_backup_interval_in_hours
  single_database_geo_backup_enabled           = var.single_database_geo_backup_enabled
  single_database_storage_account_type         = var.single_database_storage_account_type
  single_database_replica_create_mode          = var.single_database_replica_create_mode
  enable_single_database_short_term_retention  = var.enable_single_database_short_term_retention
  enable_single_database_long_term_retention   = var.enable_single_database_long_term_retention
  single_database_ltrp_weekly_retention        = var.single_database_ltrp_weekly_retention
  single_database_ltrp_monthly_retention       = var.single_database_ltrp_monthly_retention
  single_database_ltrp_yearly_retention        = var.single_database_ltrp_yearly_retention
  single_database_ltrp_week_of_year            = var.single_database_ltrp_week_of_year
  single_database_read_replica_count           = var.single_database_read_replica_count
  single_database_read_scale                   = var.single_database_read_scale
  single_database_enable_autotune              = var.single_database_enable_autotune
  single_database_enable_maintenance_config    = var.single_database_enable_maintenance_config
  enable_single_database_delete_lock           = var.enable_single_database_delete_lock

  depends_on = [
    module.sql_server,
    azurerm_monitor_action_group.action_group
  ]
}

resource "azurerm_monitor_action_group" "action_group" {
  count               = var.deploy_sql_single_database ? 1 : 0
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = "sqlalertsag"
  tags                = local.tags

  email_receiver {
    name                    = "${var.action_group_name}-email-receiver"
    email_address           = var.action_group_alerts_email_id
    use_common_alert_schema = true
  }

  depends_on = [
    module.sql_server
  ]
}

resource "azurerm_role_assignment" "sqlserver_useridentity_rback" {
  scope                =module.sql_server.sql_server_id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.seventy5_user_identity.principal_id
 
  depends_on = [
    module.sql_server,
    azurerm_user_assigned_identity.seventy5_user_identity
  ]
}

resource "azurerm_role_assignment" "associating_user_identity" {
  scope                = module.sql_server.sql_server_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.seventy5_user_identity.principal_id
 
  # server_id            = module.sql_server[0].sql_server_id
  principal_type       = "ServicePrincipal"
  # principal_id         = azurerm_user_assigned_identity.seventy5_user_identity[0].principal_id
  # role                 = "Contributor"

  depends_on = [
    module.sql_server,
    azurerm_user_assigned_identity.seventy5_user_identity
  ]
}  

resource "azurerm_role_assignment" "sqldb_useridentity_rback" {
  scope                = tostring(module.sql_single_database[0].sql_single_database_id)
  role_definition_name = "SQL Server Contributor"
  principal_id         = azurerm_user_assigned_identity.seventy5_user_identity.principal_id
 
  depends_on = [
    module.sql_server,
    azurerm_user_assigned_identity.seventy5_user_identity
  ]
}
