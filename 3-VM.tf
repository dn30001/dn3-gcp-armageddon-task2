resource "google_compute_instance" "dn3-vm-tf" {
  boot_disk {
    auto_delete = true
    device_name = "dn3-vm-tf"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240415"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "n2-standard-2"

  metadata = {
    startup-script = "apt update\napt install -y apache2\ncat <<EOF > /var/www/html/index.html\n<html><body>\n<h2>Welcome to Armageddon</h2>\n<h3>Created with a direct input startup script!</h3>\n<h4>KEISHA IS WATCHING!! SO I SHOWED HER THE BUSINESS</h4>\n</body></html>\nEOF\n"
  }

  name = "dn3-vm-tf"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/bionic-flux-414109/regions/asia-southeast1/subnetworks/sub-sg"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "380985038603-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server", "https-server", "lb-health-check"]
  zone = "asia-southeast1-b"
}



output "vpc" {
  value       = google_compute_network.custom-vpc-tf.self_link
  description = "The ID of the VPC"
}

output "instance_public_ip" {
  value       = google_compute_instance.dn3-vm-tf.network_interface[0].access_config[0].nat_ip
  description = "The public IP address of the web server"
}

output "instance_subnet" {
  value       = google_compute_instance.dn3-vm-tf.network_interface[0].subnetwork
  description = "The subnet of the VM instance"
}

output "instance_internal_ip" {
  value       = google_compute_instance.dn3-vm-tf.network_interface[0].network_ip
  description = "The internal IP address of the VM instance"
}


