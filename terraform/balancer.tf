#создаем target group
resource "yandex_alb_target_group" "web_tg" {
  name = "web-target-group-${var.flow}"

  target {
    subnet_id  = yandex_vpc_subnet.develop_a.id
    ip_address = yandex_compute_instance.web_a.network_interface.0.ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.develop_b.id
    ip_address = yandex_compute_instance.web_b.network_interface.0.ip_address
  }
}

#создаем backend group
resource "yandex_alb_backend_group" "web_bg" {
  name = "web-backend-group-${var.flow}"

  http_backend {
    name             = "web-backend"
    port             = 80
    target_group_ids = [yandex_alb_target_group.web_tg.id]

    healthcheck {
      timeout          = "3s"
      interval         = "5s"
      healthcheck_port = 80

      http_healthcheck {
        path = "/"
      }
    }
  }
}

#создаем http router
resource "yandex_alb_http_router" "web_router" {
  name = "web-router-${var.flow}"
}

#создаем virtual host
resource "yandex_alb_virtual_host" "web_host" {
  name           = "web-host"
  http_router_id = yandex_alb_http_router.web_router.id

  route {
    name = "web-route"

    http_route {
      http_match {
        path {
          prefix = "/"
        }
      }

      http_route_action {
        backend_group_id = yandex_alb_backend_group.web_bg.id
      }
    }
  }
}

#создаем application load balancer
resource "yandex_alb_load_balancer" "web_lb" {
  name               = "web-load-balancer-${var.flow}"
  network_id         = yandex_vpc_network.develop.id
  security_group_ids = [yandex_vpc_security_group.alb.id]

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.public.id
    }
  }

  listener {
    name = "http-listener"

    endpoint {
      address {
        external_ipv4_address {}
      }

      ports = [80]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.web_router.id
      }
    }
  }
}