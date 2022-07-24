# Random identifier to avoid collisions
resource "random_string" "number" {
  length  = 4
  upper   = false
  lower   = false
  numeric = true
  special = false
}

# Create virtual network
resource "azurerm_virtual_network" "team3_virtual_network" {
  name                = "team3vnet${random_string.number.result}"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# Create subnet
resource "azurerm_subnet" "team3subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.team3_virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public ip
resource "azurerm_public_ip" "team3_public_ip" {
  name                = var.public_ip_name
  location            = var.resource_group_location 
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  domain_name_label   = "team3"
}

# Cretae network security group
resource "azurerm_network_security_group" "team3_network_security_group" {
  name                = var.network_security_group_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

# Rules for the network security group
# Allow SSH
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  # Allow http
  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  # Allow Prometheus
  security_rule {
    name                       = "Prometheus"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9090"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  # Allow Node Exporter
  security_rule {
    name                       = "Node Exporter"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9100"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  # Allow Alert Manager
  security_rule {
    name                       = "Alert Manager"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9093"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  # Allow Grafana
  security_rule {
    name                       = "Grafana"
    priority                   = 1006
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "team3_nic" {
  name                = var.network_interface_configuration.ipconfigurationname
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.network_interface_configuration.resourcename
    subnet_id                     = azurerm_subnet.team3subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.team3_public_ip.id
  }
}

# Link network security group with VM network interface
resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.team3_nic.id 
  network_security_group_id = azurerm_network_security_group.team3_network_security_group.id
}

# Copy CTW Academy public SSH Key
resource "azurerm_ssh_public_key" "ssh_ssh" {
  name                = var.ssh_public_key
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  public_key          = file("~/.ssh/id_rsa.pub")
}

# Create storage account to store VM boot logs
resource "azurerm_storage_account" "team3_storage_account" {
  name                     = "team3storage${random_string.number.result}"
  location                 = var.resource_group_location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create Virtual Machine
resource "azurerm_linux_virtual_machine" "team3_virtual_machine" {
  name                  = var.linux_virtual_machine_name
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.team3_nic.id]
  size                  = "Standard_D4_v3"
  computer_name         = "team3linuxvm"
  admin_username        = "ssh"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "ssh"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "team3diskos"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.team3_storage_account.primary_blob_endpoint
  }
}