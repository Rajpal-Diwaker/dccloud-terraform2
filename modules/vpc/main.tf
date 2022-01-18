resource "google_compute_network" "network" {
    name        = "custom-vpc"
    project     = "custom-valve-332208"
    subnetworks = [
        {
            region           = "us-east1"
            cidr             = "192.168.11.0/24"
            enable_flow_logs = "true"
            private_ip_google_access = "false"
        },
        {
            region  = "us-east4"
            cidr    = "192.168.12.0/24"
        }
    ]

    // pass this when creating custom subnetworks
    auto_create_subnetworks = "false"
}