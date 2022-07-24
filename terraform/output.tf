# Output public IP address
output "public_ip_address" {
  value = azurerm_linux_virtual_machine.team3_virtual_machine.public_ip_address
}
# Output Account ID
output "account_id" {
  value = data.azurerm_client_config.current.client_id
}
# Output Fully Qualified Domain Name
output "fqdn" {
  value = azurerm_public_ip.team3_public_ip.fqdn
}
