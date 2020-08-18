output "virtual_machine_names" {

  value = vsphere_virtual_machine.terraform-vm.*.name
}

output "virtual_machine_ids" {

  value = vsphere_virtual_machine.terraform-vm.*.id
}

output "virtual_machine_default_ips" {

  value = vsphere_virtual_machine.terraform-vm.*.default_ip_address
}

