resource "google_dataproc_cluster" "sparktodp" {
    name   = "sparktodp"
    region = "us-west1"

    cluster_config {
        staging_bucket = "[qwiklabs-gcp-00-47a2652b8a80]"

        master_config {
            num_instances = 1
            machine_type  = "e2-standard-2"
            disk_config {
            boot_disk_type    = "pd-ssd"
            boot_disk_size_gb = 30
            }
        }

        worker_config {
            num_instances    = 2
            machine_type     = "e2-standard-2"
            disk_config {
            boot_disk_size_gb = 30
            }
        }

        # Override or set some custom properties
        software_config {
            image_version = "2.1-debian11"
            override_properties = {
            "dataproc:dataproc.allow.zero.workers" = "true"
            }
        }

        endpoint_config {
               enable_http_port_access = "true"
        }
    }
}