resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/hosts.ini"

  content = templatefile("${path.module}/hosts.ini.tftpl", {
    bastion_ip       = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
    web_a_ip         = yandex_compute_instance.web_a.network_interface[0].ip_address
    web_b_ip         = yandex_compute_instance.web_b.network_interface[0].ip_address
    prometheus_ip    = yandex_compute_instance.prometheus.network_interface[0].ip_address
    grafana_ip       = yandex_compute_instance.grafana.network_interface[0].ip_address
    elasticsearch_ip = yandex_compute_instance.elasticsearch.network_interface[0].ip_address
    kibana_ip        = yandex_compute_instance.kibana.network_interface[0].ip_address
  })
}