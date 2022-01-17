terraform {
  required_version = ">= 0.13.1" # see https://releases.hashicorp.com/terraform/
}

locals {
  instance_name = format("%s-%s", var.instance_name, var.suffix)
  region        = data.google_client_config.google_client.region
  zone          = format("%s-%s", local.region, var.zone)
  network_tags  = tolist(toset(var.network_tags))

  name_static_vm_ip = format("%s-ext-ip-%s", var.instance_name, var.suffix)

  sa_id = format("%s-sa-%s", var.instance_name, var.suffix)
}

resource "google_compute_address" "gce_static_ip" {
  name       = local.name_static_vm_ip
  region     = local.region
  depends_on = [google_project_service.networking_api]

  timeouts {
    create = var.static_ip_timeout
    delete = var.static_ip_timeout
  }
}

resource "google_compute_instance" "gce" {
  project      = var.gcp_project_id
  name         = local.instance_name
  machine_type = var.instance_machine_type
  zone         = local.zone
  tags         = local.network_tags

  boot_disk {
    initialize_params {
      size  = var.boot_disk_size
      type  = var.boot_disk_type
      image = var.boot_disk_image
    }
  }
  network_interface {
    network = var.vpc_network_name
    access_config {
      nat_ip       = google_compute_address.gce_static_ip.address
      network_tier = "PREMIUM"
    }
  }

  lifecycle {
    ignore_changes = [
      attached_disk,
    ]
  }
  
  depends_on = [google_project_service.compute_api]

  timeouts {
    create = var.vm_instance_timeout
    update = var.vm_instance_timeout
    delete = var.vm_instance_timeout
  }
}

data "google_client_config" "google_client" {}
