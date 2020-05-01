# Copyright (C) 2019-2020 Nicolas Lamirault <nicolas.lamirault@gmail.com>
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "google_compute_network" "main" {
  name                    = var.network
  description             = "Created by Terraform"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "main" {
  name          = var.subnet_network
  description   = "Created by Terraform"
  ip_cidr_range = var.range
  region        = var.location
  network       = google_compute_network.main.name

  secondary_ip_range {
    ip_cidr_range = var.gke_services_subnet_cidr
    range_name    = var.gke_services_subnet
  }
  secondary_ip_range {
    ip_cidr_range = var.gke_pods_subnet_cidr
    range_name    = var.gke_pods_subnet
  }
}

module "gke" {
  source = "../modules/kubernetes"

  project  = var.project
  location = var.location

  network        = google_compute_network.main.name
  subnet_network = google_compute_subnetwork.main.name

  name                       = var.name
  release_channel            = var.release_channel
  network_config             = var.network_config
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  master_authorized_networks = var.master_authorized_networks
  rbac_group_domain          = var.rbac_group_domain

  maintenance_start_time = var.maintenance_start_time

  labels = var.labels

  network_policy             = var.network_policy
  auto_scaling               = var.auto_scaling
  hpa                        = var.hpa
  pod_security_policy        = var.pod_security_policy
  monitoring_service         = var.monitoring_service
  logging_service            = var.logging_service
  binary_authorization       = var.binary_authorization
  google_cloud_load_balancer = var.google_cloud_load_balancer
  istio                      = var.istio
  cloudrun                   = var.cloudrun

  node_pool_name = var.node_pool_name
  node_count     = var.node_count
  max_node_count = var.max_node_count
  min_node_count = var.min_node_count
  machine_type   = var.machine_type
  disk_size_gb   = var.disk_size_gb
  auto_upgrade   = var.auto_upgrade
  auto_repair    = var.auto_repair
  image_type     = var.image_type
  preemptible    = var.preemptible
  node_labels    = var.node_labels
  node_tags      = var.node_tags
}
