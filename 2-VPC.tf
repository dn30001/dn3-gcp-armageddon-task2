resource "google_compute_network" "custom-vpc-tf" {
  name =  "custom-vpc-tf"
  auto_create_subnetworks = false
}

output "custom" {
  value = google_compute_network.custom-vpc-tf.id
}

resource "google_compute_subnetwork" "sub-sg" {
  name =  "sub-sg"
  network =  google_compute_network.custom-vpc-tf.id
  ip_cidr_range = "10.5.0.0/24"
  region = "asia-southeast1"
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow-icmp" {
  name = "allow-icmp"
  network =  google_compute_network.custom-vpc-tf.id
  allow {
    protocol = "icmp"
  }
  source_ranges = ["66.210.251.119/32"]
  priority = 455

}

