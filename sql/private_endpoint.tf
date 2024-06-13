resource "azurerm_private_endpoint" "private_endpoints" {
  for_each = var.sql_private_endpoints

  name                = each.key
  location            = each.value.subnet_location
  resource_group_name = var.resource_group_name
  subnet_id           = each.value.private_endpoint_subnet_id

  private_dns_zone_group {
    name                 = "${each.key}-dns-zone-group"
    private_dns_zone_ids = [each.value.private_dns_zone_id]
  }

  private_service_connection {
    name                           = "${each.key}-ps"
    private_connection_resource_id = module.sql_server.sql_server_id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}
