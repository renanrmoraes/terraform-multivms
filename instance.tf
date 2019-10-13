data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.vsphere_resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vsphere_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "rheltpl" {
  name          = "${var.vsphere_virtual_machine_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "centostpl" {
  name          = "${var.lb_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "master" {
  count			   = "${var.master_count}"
  name             = "${var.master_name}${count.index + 1}"
  folder           = "${var.vsphere_folder}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  scsi_type = "${data.vsphere_virtual_machine.rheltpl.scsi_type}"

  num_cpus = 4
  memory   = 16384
  guest_id = "${var.master_guest_id}"
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size  = 30
	unit_number = 0
	thin_provisioned =  "${var.disk0_thin_provisioned}"
  }

  disk {
    label = "disk1"
    size  = 25
	unit_number = 1
		thin_provisioned =  "${var.disk1_thin_provisioned}"
  }

  
  clone {
    template_uuid = "${data.vsphere_virtual_machine.rheltpl.id}"
    
	customize {
      linux_options{
        host_name = "${var.master_name}${count.index + 1}"
        domain = "${var.domain_sufix}"
      }
      network_interface {
        ipv4_address = "${var.vm_ip}${var.ip + count.index + 1}"
        ipv4_netmask = "24"
      }

      ipv4_gateway = "${var.ipv4_gw}"
      dns_suffix_list = ["${var.domain_sufix}"]
      dns_server_list = ["${var.dns_srv}"]
    }
  }
}

resource "dns_a_record_set" "master" {
  count = "${var.master_count}"
  zone = "${var.domain_sufix}."
  name = "${var.master_name}${count.index + 1}"
  addresses = [
    "${var.vm_ip}${var.ip + count.index + 1}",
  ]
}

resource "dns_ptr_record" "master" {
  count = "${var.master_count}"
  zone = "1.168.192.in-addr.arpa."
  name = "${var.ip + count.index + 1}"
  ptr  = "${var.master_name}${count.index + 1}.${var.domain_sufix}."
}


resource "vsphere_virtual_machine" "infra" {
  count			   = "${var.infra_count}"
  name             = "${var.infra_name}${count.index + 1}"
  folder           = "${var.vsphere_folder}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  scsi_type = "${data.vsphere_virtual_machine.rheltpl.scsi_type}"

  num_cpus = 4
  memory   = 16384
  guest_id = "${var.master_guest_id}"
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size  = 30
	unit_number = 0
	thin_provisioned =  "${var.disk0_thin_provisioned}"
  }

  disk {
    label = "disk1"
    size  = 25
	unit_number = 1
		thin_provisioned =  "${var.disk1_thin_provisioned}"
  }

  
  clone {
    template_uuid = "${data.vsphere_virtual_machine.rheltpl.id}"
    
	customize {
      linux_options{
        host_name = "${var.infra_name}${count.index + 1}"
        domain = "${var.domain_sufix}"
      }
      network_interface {
        ipv4_address = "${var.vm_ip}${var.ip + var.master_count + count.index + 1}"
        ipv4_netmask = "24"
      }

      ipv4_gateway = "${var.ipv4_gw}"
      dns_suffix_list = ["${var.domain_sufix}"]
      dns_server_list = ["${var.dns_srv}"]
    }
  }
}

resource "dns_a_record_set" "infra" {
  count = "${var.infra_count}"
  zone = "${var.domain_sufix}."
  name = "${var.infra_name}${count.index + 1}"
  addresses = [
    "${var.vm_ip}${var.ip + var.master_count + count.index + 1}",
  ]
}

resource "dns_ptr_record" "infra" {
  count = "${var.infra_count}"
  zone = "1.168.192.in-addr.arpa."
  name = "${var.ip + var.master_count + count.index + 1}"
  ptr  = "${var.infra_name}${count.index + 1}.${var.domain_sufix}."
}

resource "vsphere_virtual_machine" "app" {
  count			   = "${var.app_count}"
  name             = "${var.app_name}${count.index + 1}"
  folder           = "${var.vsphere_folder}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  scsi_type = "${data.vsphere_virtual_machine.rheltpl.scsi_type}"

  num_cpus = 4
  memory   = 80192
  guest_id = "${var.master_guest_id}"
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size  = 30
	unit_number = 0
	thin_provisioned =  "${var.disk0_thin_provisioned}"
  }

  disk {
    label = "disk1"
    size  = 25
	unit_number = 1
		thin_provisioned =  "${var.disk1_thin_provisioned}"
  }

  
  clone {
    template_uuid = "${data.vsphere_virtual_machine.rheltpl.id}"
    
	customize {
      linux_options{
        host_name = "${var.app_name}${count.index + 1}"
        domain = "${var.domain_sufix}"
      }
      network_interface {
        ipv4_address = "${var.vm_ip}${var.ip + var.master_count + var.infra_count + count.index + 1}"
        ipv4_netmask = "24"
      }

      ipv4_gateway = "${var.ipv4_gw}"
      dns_suffix_list = ["${var.domain_sufix}"]
      dns_server_list = ["${var.dns_srv}"]
    }
  }
}

resource "dns_a_record_set" "app" {
  count = "${var.app_count}"
  zone = "${var.domain_sufix}."
  name = "${var.app_name}${count.index + 1}"
  addresses = [
    "${var.vm_ip}${var.ip + var.master_count + var.infra_count + count.index + 1}",
  ]
}

resource "dns_ptr_record" "app" {
  count = "${var.app_count}"
  zone = "1.168.192.in-addr.arpa."
  name = "${var.ip + var.master_count + var.infra_count + count.index + 1}"
  ptr  = "${var.app_name}${count.index + 1}.${var.domain_sufix}."
}

resource "vsphere_virtual_machine" "lb" {
  count			   = "${var.lb_count}"
  name             = "${var.lb_name}${count.index + 1}"
  folder           = "${var.vsphere_folder}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  scsi_type = "${data.vsphere_virtual_machine.centostpl.scsi_type}"

  num_cpus = 1
  memory   = 4096
  guest_id = "${var.lb_guest_id}"
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size  = 30
	unit_number = 0
	thin_provisioned =  "${var.disk0_thin_provisioned}"
  }

  disk {
    label = "disk1"
    size  = 25
	unit_number = 1
		thin_provisioned =  "${var.disk1_thin_provisioned}"
  }

  
  clone {
    template_uuid = "${data.vsphere_virtual_machine.centostpl.id}"
    
	customize {
      linux_options{
        host_name = "${var.lb_name}${count.index + 1}"
        domain = "${var.domain_sufix}"
      }
      network_interface {
        ipv4_address = "${var.vm_ip}${var.ip + count.index - 1}"
        ipv4_netmask = "24"
      }

      ipv4_gateway = "${var.ipv4_gw}"
      dns_suffix_list = ["${var.domain_sufix}"]
      dns_server_list = ["${var.dns_srv}"]
    }
  }
}

resource "dns_a_record_set" "lb" {
  count = "${var.lb_count}"
  zone = "${var.domain_sufix}."
  name = "${var.lb_name}${count.index + 1}"
  addresses = [
    "${var.vm_ip}${var.ip + count.index - 1}",
  ]
}

resource "dns_ptr_record" "lb" {
  count = "${var.lb_count}"
  zone = "1.168.192.in-addr.arpa."
  name = "${var.ip + count.index - 1}"
  ptr  = "${var.lb_name}${count.index + 1}.${var.domain_sufix}."
}