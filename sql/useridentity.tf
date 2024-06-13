module "cluster_details" {
  # This module does not require a pinned version
  # tflint-ignore: terraform_module_pinned_source
  source       = "github.com/krogertechnology/az-global-variables//galaxy_outputs/"
  cluster_name = var.cluster_name
}

resource "azurerm_user_assigned_identity" "seventy5_user_identity" {
  location            = var.location
  name                = "id-seventy5-${var.environment}-${var.location}"
  resource_group_name = var.resource_group_name
  depends_on = [
    module.sql_server,
    azurerm_monitor_action_group.action_group,
    module.sql_single_database
  ]
}

resource "azurerm_federated_identity_credential" "seventy5_federated_identity_credential" {
  name                = var.federated_identity_credential_name
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer
  parent_id           = azurerm_user_assigned_identity.seventy5_user_identity.id
  subject             = "system:serviceaccount:${var.namespace}:${var.serviceaccount}"

  depends_on = [
    module.sql_server,
    azurerm_monitor_action_group.action_group,
    module.sql_single_database,
    azurerm_user_assigned_identity.seventy5_user_identity
  ]
}
