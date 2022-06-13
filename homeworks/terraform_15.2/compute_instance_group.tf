resource "yandex_iam_service_account" "ig-sa" {
  folder_id = local.folder_id
  name        = "ig-sa"
  description = "service account to manage instance groups"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = local.folder_id
  role      = "editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.ig-sa.id}",
  ]
}

resource "yandex_compute_instance_group" "ig-1" {
  
  name               = "fixed-ig-with-balancer"
  folder_id          = local.folder_id
  service_account_id = yandex_iam_service_account.ig-sa.id
  
  instance_template {
    
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"     # lamp
      }
    }

    network_interface {
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      nat        = true
    }

    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
      user-data = <<SCRIPT
#!/bin/bash
echo "<html><body><p>Content from $(hostname -I)</p><img src='https://storage.yandexcloud.net/${yandex_storage_bucket.bucket-1.id}/${yandex_storage_object.image-1.id}'></body></html>" > /var/www/html/index.html
SCRIPT
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }
  
  health_check {
    http_options {
      port = 80
      path = "/"
    }
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "load balancer target group"
  }
}
