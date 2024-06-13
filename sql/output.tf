output "sql_server_id" {
  value = module.sql_server.sql_server_id
}

output "sql_server_name" {
  value = module.sql_server.sql_server_name
}

output "sql_server_password" {
  value = module.sql_server.sql_server_password
  sensitive = true
}

output "sql_single_database_id" {
  value = module.sql_single_database[*].sql_single_database_id
}

output "sql_single_database_name" {
  value = module.sql_single_database[*].sql_single_database_name
}
