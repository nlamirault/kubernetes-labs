# terraform-gcp-kubernetes

Terraform module which configure a Kubernetes cluster on Google Cloud

## Versions

Use Terraform `0.12` and Terraform Provider Google `3.5+` and Google Beta `3.5+`.

These types of resources are supported:

* [google_container_cluster](https://www.terraform.io/docs/providers/google/r/container_cluster.html)
* [google_container_node_pool](https://www.terraform.io/docs/providers/google/r/container_node_pool.html)

## Usage

```hcl
module "gke" {
  source = "git::ssh://git@github.com/nlamirault/portefaix.git//gke/terraform/modules/kubernetes?ref=v0.1.0"

  project    = var.project
  location   = var.location

  name            = "my-cluster"
  release_channel = "STABLE"
  network_config  = {
    enable_natgw   = false
    enable_ssh     = false
    private_master = false
    private_nodes  = true
    node_cidr      = "10.0.0.0/24"
    service_cidr   = "10.1.0.0/24"
    pod_cidr       = "10.2.0.0/24"
    master_cidr    = "10.20.30.0/28"
  }
  master_authorized_networks = {
    my-bastion = "10.11.12.13"
  }
  maintenance_start_time = "03:00"
  labels = {
    customer = "a-customer"
    env      = "prod"
  }

  network_policy             = true
  auto_scaling               = true
  hpa                        = true
  pod_security_policy        = true
  monitoring_service         = true
  logging_service            = true
  binary_authorization       = true
  google_cloud_load_balancer = true
  istio                      = false
  cloudrun                   = false
}
```

This module creates :

* a Kubernetes cluster

## Documentation

