provider "vsphere" {
    vsphere_server = "${var.vsphere_server}"
    user = "${var.vsphere_user}"
    password = "${var.vsphere_password}"
    allow_unverified_ssl = true
}

## Build VM
data "vsphere_datacenter" "dc" {
  name = "casa.home"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {}

data "vsphere_network" "mgmt_lan" {
  name          = "VMNetwork"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name = "Clone"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "test4" {
  name             = "test4"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  num_cpus   = 1
  memory     = 2048
  wait_for_guest_net_timeout = 0
  guest_id = "centos7_64Guest"
  guest_ip_addresses = []
  nested_hv_enabled =true
  network_interface {
   network_id     = "${data.vsphere_network.mgmt_lan.id}"
   adapter_type   = "e1000"
  }

#network_interface {
 #      ipv4_address    = "192.168.2.18"
  #     ipv4_netmask    = "24"
   #    dns_server_list = ["192.168.2.10", "8.8.8.8"]
    #   network_id      = "${data.vsphere_network.mgmt_lan.id}"
  

  disk {
   size             = 16
   label             = "test4.vmdk"
   eagerly_scrub    = false
   thin_provisioned = true
  }
 
#  cdrom {
 #   datastore_id = "${data.vsphere_datastore.datastore.id}"
 #   path         = "home/osboxes/Downloads/CentOS-8.5.2111-x86_64-boot.iso"
  #}

}
