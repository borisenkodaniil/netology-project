resource "yandex_compute_snapshot_schedule" "backup" {
  name = "daily-backup-${var.flow}"

  schedule_policy {
    expression = "0 0 * * *"
  }

  retention_period = "168h"

  disk_ids = [
    yandex_compute_instance.web_a.boot_disk[0].disk_id,
    yandex_compute_instance.web_b.boot_disk[0].disk_id,
    yandex_compute_instance.prometheus.boot_disk[0].disk_id,
    yandex_compute_instance.grafana.boot_disk[0].disk_id,
    yandex_compute_instance.elasticsearch.boot_disk[0].disk_id,
    yandex_compute_instance.kibana.boot_disk[0].disk_id,
    yandex_compute_instance.bastion.boot_disk[0].disk_id
  ]
}