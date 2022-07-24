# Varibel for resource group name
variable "resource_group_name" {
  default     = "resource-rg"
  description = "Resource group name."
}
# Varibel for resource group location
variable "resource_group_location" {
  default     = "germanywestcentral"
  description = "Location of the resource group."
}
# Varibel for azure subscription
variable "azure_subscription_id" {
  type        = string
  default     = "470bd2ee-0973-4f49-a719-dc721d0d6e4f"
  description = "Azure Account"
}
# Variable for azure tenant ID
variable "arm_tenant_id" {
  type        = string
  description = "Azure tenant id"
  default     = "61f30b8e-4f6b-44fe-9bc2-041e3a9f7346"
}
# varibe for subnet name
variable "subnet_name" {
  type        = string
  default     = "team3subnet"
  description = "Team 3 subnet name"
}
# Variable for public IP name
variable "public_ip_name" {
  type        = string
  default     = "team3publicip"
  description = "Team 3 public ip name"
}
# Variable for network security group
variable "network_security_group_name" {
  type        = string
  default     = "team3networksecuritygroup"
  description = "Team 3 security group"
}

variable "network_interface_configuration" {
  description = "Team3 network interface configuration"
  type        = map(string)
  default = {
    ipconfigurationname = "tem3nic"
    resourcename           = "team3nic",
  }
}
# Variable for SSH Key
variable "ssh_public_key" {
  type        = string
  default     = "ssh"
  description = "Name for SSH public key"
}
# Variable for Virtual Machine
variable "linux_virtual_machine_name" {
  type        = string
  default     = "team3linuxvm"
  description = "Team 3 virtual machine name"
}