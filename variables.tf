# vsphere login account. defaults to admin account
variable "vsphere_user" {}

# vsphere account password. empty by default.
variable "vsphere_password" {}

# vsphere server, defaults to localhost
variable "vsphere_server" {}

# vsphere datacenter the virtual machine will be deployed to. empty by default.
variable "vsphere_datacenter" {}

# vsphere resource pool the virtual machine will be deployed to. empty by default.
variable "vsphere_resource_pool" {}

# vsphere datastore the virtual machine will be deployed to. empty by default.
variable "vsphere_datastore" {}

# vsphere network the virtual machine will be connected to. empty by default.
variable "vsphere_network" {}

# vsphere folder.
variable "vsphere_folder" {}

# vsphere virtual machine template that the virtual machine will be cloned from. empty by default.
variable "vsphere_virtual_machine_template" {}

# the name of the vsphere virtual machine that is created. empty by default.
variable "domain_sufix" {}
variable "ipv4_gw" {}
variable "dns_srv" {}

variable disk0_thin_provisioned { 
	default = true
}

variable disk1_thin_provisioned { 
	default = true
}

variable "master_count" {}
variable "infra_count" {}
variable "app_count" {}

variable "master_name" {}
variable "infra_name" {}
variable "app_name" {}
variable "master_guest_id" {
	default = "rhel7_64Guest"
}

variable "lb_count" {}
variable "lb_name" {}
variable "lb_template" {}
variable "lb_guest_id" {
	default = "centos7_64Guest"
}

variable "vm_ip" {
	default = "192.168.1."
}

variable "ip" {}

variable "dns_ip" {
  description = "IP address of Master DNS-Server"
  default = "192.168.1.10"
}
variable "dns_key" {
  description = "name of the DNS-Key to user"
  default = "terraform."
}
variable "dns_key_secret" {
  description = "base 64 encoded string"
  default = "YmluZDIwMTkK"
}
