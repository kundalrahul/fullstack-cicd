provider "google" {
  project = "ica3-428602"
  region  = "us-central1"
}

resource "google_container_cluster" "primary" {
  name     = "autopilot-cluster-1"
  location = "us-central1"

  node_config {
    machine_type = "e2-micro"  # Smallest machine type
    disk_size_gb = 10          # Minimum disk size
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }

  initial_node_count = 1  # Minimum number of nodes
}

resource "google_sql_database_instance" "postgres" {
  name             = "postgres-instance"
  database_version = "POSTGRES_13"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"
    disk_size = 10  # Reduce the disk size
  }
}

resource "google_sql_database" "db" {
  name     = "ica3"
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "user" {
  name     = "root"
  instance = google_sql_database_instance.postgres.name
  password = "root"
}

output "instance_connection_name" {
  value = google_sql_database_instance.postgres.connection_name
}