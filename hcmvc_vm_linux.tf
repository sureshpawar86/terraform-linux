data "vsphere_datacenter" "dc" {
  name = "hcm-dc65-01"
}
data "vsphere_datastore" "datastore" {
  name          = "esx09-datastore3"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_compute_cluster" "cluster" {
    name          = "hcm-cluster01"
    datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "network" {
  name          = "dev-2942-linuxdhcp"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "template" {
  name          = "hcm-centos65-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "folder" {
  path = "Suresh Pawar"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "terraform-vm" {
  name             = "tf-centos65x64"
  folder           = "Suresh Pawar"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  count            = 1
  num_cpus = 1
  memory   = 2048
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    unit_number      = 0
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
 
  disk {
    label            = "disk1"
    unit_number      = 1
    size             = data.vsphere_virtual_machine.template.disks.1.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.1.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.1.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "tf-centos65x64"
        domain    = "rackwareinc.lab"
      }
      network_interface {}

    }
  }
}

#resource "vsphere_virtual_machine_snapshot" "demo1" {
#  virtual_machine_uuid = vsphere_virtual_machine.terraform-vm.id
#  snapshot_name        = "Clean_OS"
#  description          = "This is Demo Snapshot"
#  memory               = "false"
#  quiesce              = "false"
#}

