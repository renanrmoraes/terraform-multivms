provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"
  allow_unverified_ssl = true
}

provider "dns" {
  update {
    server        = "${var.dns_ip}"
    key_name      = "${var.dns_key}"
    key_algorithm = "hmac-md5"
    key_secret    = "${var.dns_key_secret}"
  }
}