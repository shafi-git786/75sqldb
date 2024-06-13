########## SQL Server ############

variable "resource_group_name" {
  description = "The name of the resource group in which SQL Server to be created"
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists"
  default     = "eastus2"
}

variable "environment" {
  description = "Specifies the deployment environment"
  default     = "dev"
}

variable "subscription_id" {
  description = "Id of the subscription in which sql server is deployed"
}

variable "mandatory_tags" {
  description = "A map of required tags for Kroger Azure Resources."
  type = object({
    owner               = string
    cost-center         = string
    application-name    = string
    environment         = string
    spm-id              = string
    lob                 = string
    data-classification = string
  })
  validation {
    condition     = var.mandatory_tags.data-classification == "Confidential" || var.mandatory_tags.data-classification == "Highly Confidential" || var.mandatory_tags.data-classification == "Internal" || var.mandatory_tags.data-classification == "Public"
    error_message = "The data classification tagst must be set to Confidential,Highly Confidential,Internal or Public."
  }
}

variable "additional_tags" {
  description = "A map of additonal tags teams can link to their resources."
  type        = map(string)
  default     = {}
}

variable "sql_server_version" {
  description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)"
  default     = "12.0"
}

variable "minimum_tls_version" {
  description = "The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server. Valid values are: 1.0, 1.1 and 1.2."
  default     = "1.2"
}

variable "firewall_rules" {
  description = "A map of firewall rules to attach to sql server"
  type        = list(map(string))
  default     = []
}

variable "sql_virtual_network_rules" {
  type    = list(map(string))
  default = []
}

variable "sql_server_admin_login_name" {
  description = "The Administrator Login name for the SQL Server"
}

variable "sql_connection_policy" {
  description = "The connection policy the sql server will use. Possible values are Default, Proxy, and Redirect"
  default     = "Default"
}

variable "sql_server_aad_admin_login_name" {
  description = "The login username of the Azure AD Administrator of this SQL Server"
  default     = null
}

variable "active_directory_admin_object_id" {
  description = "The object id of the Azure AD Administrator for this SQL Server. This will also be used in azure Key Vault to grant secret permissions by adding to access policies"
}

variable "sql_server_name" {
  description = "The name of the Microsoft SQL Server. This needs to be globally unique within Azure."
}

variable "enable_azuread_administrator" {
  description = "A flag to indicate whether Azure AD Administrator should be enabled for this sql server"
  type        = bool
}

variable "tenant_id" {
  description = "specify the tenant id"
  default     = "8331e14a-9134-4288-bf5a-5e2c8412f074"
}

variable "enable_sql_server_delete_lock" {
  description = "Flag to determine if a delete lock should be enabled on SQL Server"
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed for this server"
  type        = bool
}

####### Log Analytics Workspace #########
variable "deploy_sql_server_log_analytics_workspace" {
  description = "This flag will determine if a Log Analytics Workspace will be deployed in SQL Server module"
  default     = false
}
variable "log_analytics_name" {
  description = "Specifies the name of Log Analytics Workspace to create."
  default     = null
}

variable "log_analytics_sku" {
  description = "Specifies the Sku of the Log Analytics Workspace."
  default     = "PerGB2018"
}

variable "log_analytics_retention" {
  description = "The workspace data retention in days. Possible values range between 30 and 730."
  default     = "30"
}

###### Azure key Vault ###########

variable "deploy_sql_server_key_vault" {
  description = "This flag will determine if a Key Vault will be deployed in SQL Server module"
  default     = false
}
variable "keyvault_ip_rules" {
  description = "Key Vault ip rules. whitelisted kroger on-prem."
  default     = ["158.48.0.0/16"]
}

variable "keyvault_subnet_ids" {
  description = "The ID's of virtual network subnet to attch to key vault. Currently whitelisted kroger core engineering agnet subnets."
  type        = list(any)
  default = [
    "/subscriptions/5cbbab4e-7333-4ad5-9307-71f9680624b7/resourceGroups/networking-centralus/providers/Microsoft.Network/virtualNetworks/customerexperienceprod1-1-centralus-vnet/subnets/cx-tcghar-01_prod_10_243_144_64_26",
    "/subscriptions/5cbbab4e-7333-4ad5-9307-71f9680624b7/resourceGroups/networking-eastus2/providers/Microsoft.Network/virtualNetworks/customerexperienceprod1-1-eastus2-vnet/subnets/cx-tcghar-01_prod_10_135_73_0_26",
    "/subscriptions/45c9a658-02d1-4c1b-a2ec-0a38383c3259/resourceGroups/networking-centralus/providers/Microsoft.Network/virtualNetworks/vnet-tsa-centralus-spoke/subnets/snet-cicd-runners-centralus-nonprod"
  ]
}

variable "key_vault_name" {
  description = "The name of the key vault to create"
  default     = null
}

variable "key_vault_sku" {
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  default     = "standard"
}

variable "key_vault_soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
  default     = "60"
}

variable "kv_access_object_ids" {
  description = "The object ID's of the groups or users to add for key vault secrets access"
  type = map(object(
    {
      key_permissions    = list(string)
      secret_permissions = list(string)
    }
  ))
  default = {}
}

variable "service_principal_object_id" {
  description = "The object id of the service principal used to add as key vault access policies to create secrets"
  default     = ""
}

########## SQL Single database ###########

variable "deploy_sql_single_database" {
  description = "is deploy sql single database true or flase"
  type        = bool
  default     = false
}

variable "single_database_name" {
  description = "Name for the Ms SQL Database"
  default     = null
}

variable "single_database_sku_name" {
  description = "Name of the sku used by the database. Changing this forces a new resource to be created. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100"
  default     = null
}

variable "serverless" {
  description = "Whether or not this database is serverless"
  type        = bool
  default     = false
}

variable "single_database_min_capacity" {
  description = "Minimal capacity this databases will always have allocated, if not paused. This property is only settable for General Purpose Serverless databases"
  type        = number
  default     = null
}

variable "single_database_auto_pause_delay_in_minutes" {
  description = "Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled. This property is only settable for General Purpose Serverless databases"
  type        = number
  default     = null
}

variable "single_database_max_size_gb" {
  description = "Max size of database in gigabytes"
  type        = number
  default     = null
}

variable "single_database_zone_redundant" {
  description = "whether or not this database is zone redundant"
  type        = bool
  default     = "false"
}

variable "single_database_backup_retention_days" {
  description = "Points In Time Restore configuration. Value has to be between 7 and 35."
  type        = number
  default     = null
}

variable "deploy_sql_single_database_metrics_dashboard" {
  description = "This flag will determine if a Metrics Dashboard will be deployed with SQL Single Database module"
  type        = bool
  default     = false
}

variable "single_database_enable_autotune" {
  description = "Flag to determine if autotune should be applied to Single database"
  default     = true
}

variable "single_database_enable_maintenance_config" {
  description = "Flag to determine if Maintenance Config should be applied to Single database"
  default     = true
}

variable "enable_single_database_delete_lock" {
  description = "Flag to determine if a delete lock should be enabled on SQL Single database"
  default     = false
}
######### Common ##########

variable "log" {
  type        = list(string)
  description = "available log categories for sql db diagnostic settings"
  default = [
    "SQLInsights",
    "AutomaticTuning",
    "QueryStoreRuntimeStatistics",
    "QueryStoreWaitStatistics",
    "Errors",
    "DatabaseWaitStatistics",
    "Timeouts",
    "Blocks",
    "Deadlocks",
    "SQLSecurityAuditEvents",
    "DevOpsOperationsAudit"
  ]
}

variable "metric" {
  type        = list(string)
  description = "available metric categories for sql db diagnostic settings"
  default = [
    "Basic",
    "InstanceAndAppAdvanced",
    "WorkloadManagement"
  ]
}

variable "database_collation" {
  description = "Specifies the collation of the database"
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "action_group_name" {
  description = "The name of the action group for SQL Database and elastic pool alerts"
  default     = ""
}

variable "action_group_alerts_email_id" {
  description = "The name of the email receiver. Names must be unique (case-insensitive) across all receivers within an action group"
  default     = ""
}

variable "maintenance_config" {
  type        = string
  description = " maintenance config window for the database"
  default     = "SQL_EastUS2_DB_2"
}
variable "single_database_backup_interval_in_hours" {
  description = "The hours between each differential backup. This is only applicable to live databases but not dropped databases. Value has to be 12 or 24. Defaults to 12 hours"
  default     = 12
}
variable "single_database_geo_backup_enabled" {
  description = "Flag to determine if Geo Backup should be enabled. Note: geo_backup_enabled is only applicable for DataWarehouse SKUs (DW*). This setting is ignored for all other SKUs."
  default     = false
}
variable "single_database_storage_account_type" {
  description = "Specifies the storage account type used to store backups for this database. Possible values are Geo, Local and Zone. The default value is Geo"
  default     = "Geo"
}

variable "single_database_replica_create_mode" {
  description = "The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. Mutually exclusive with import."
  default     = "Secondary"
}

variable "enable_single_database_short_term_retention" {
  description = "Flag to determins if Short Term Retenion should be enabled on Single database"
  default     = true
}
variable "enable_single_database_long_term_retention" {
  description = "Flag to determins if Long Term Retenion should be enabled on Single database"
  default     = true
}
variable "single_database_ltrp_weekly_retention" {
  description = "Long Term Retention Policy - Weekly retention. Valid value is between 1 to 520 weeks. e.g. P1Y, P1M, P1W or P7D"
  default     = "P1W"
}

variable "single_database_ltrp_monthly_retention" {
  description = "Long Term Retention Policy - Monthly retention. Valid value is between 1 to 120 months. e.g. P1Y, P1M, P4W or P30D"
  default     = "P1M"
}
variable "single_database_ltrp_yearly_retention" {
  description = "Long Term Retention Policy - Yearly retention. Valid value is between 1 to 10 years. e.g. P1Y, P12M, P52W or P365D"
  default     = "P1Y"
}
variable "single_database_ltrp_week_of_year" {
  description = "The week of year to take the yearly backup. Value has to be between 1 and 52"
  default     = 1
}

variable "single_database_read_replica_count" {
  description = "The number of readonly secondary replicas associated with the database to which readonly application intent connections may be routed. This property is only settable for Hyperscale edition databases."
  default     = 0
}
variable "single_database_read_scale" {
  description = "If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica. This property is only settable for Premium and Business Critical databases."
  default     = true
}

variable "sql_private_endpoints" {
  description = "Configuration for private endpoints to be connected to this SQL Server."
  type = map(object({
    subnet_location            = string
    private_endpoint_subnet_id = string
    private_dns_zone_id        = string
  }))
  default = {}
}

variable "federated_identity_credential_name" {
  type = string
}

variable "issuer" {
  type = string

}

variable "namespace" {
  type = string
}

variable "serviceaccount" {
  type = string
}

variable "cluster_name" {
  type = string
}
