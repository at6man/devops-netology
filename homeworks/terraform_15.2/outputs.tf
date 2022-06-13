output "internal_ip_address_vm" {
  value = yandex_compute_instance_group.ig-1.instances.*.network_interface.0.ip_address
}

output "external_ip_address_vm" {
  value = yandex_compute_instance_group.ig-1.instances.*.network_interface.0.nat_ip_address
}

output "external_ip_address_lb" {
  value = yandex_lb_network_load_balancer.load-balancer-1.listener.*.external_address_spec
}
