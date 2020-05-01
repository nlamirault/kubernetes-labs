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

#####################################################################""
# Provider

project = "portefaix-prod"

location = "europe-west1"

##############################################################################
# Kubernetes cluster


##############################################################################
# VPC

customer = "portefaix"

env = "prod"

range                    = "10.0.0.0/20"
gke_services_subnet_cidr = "10.0.16.0/20"
gke_pods_subnet_cidr     = "10.0.32.0/20"

network             = "cilium-tf-prod"
subnet_network      = "cilium-tf-prod-net"
gke_services_subnet = "cilium-tf-prod-net-gke-services"
gke_pods_subnet     = "cilium-tf-prod-net-gke-pods"


##############################################################################
# Kubernetes cluster

name = "cilium-tf-prod-cluster-gke"

release_channel = "REGULAR"

network_config = {
  enable_natgw   = true
  enable_ssh     = false
  private_master = false
  private_nodes  = true
  # master_cidr    = "10.0.64.0/28"
  pods_cidr     = "cilium-tf-prod-net-gke-pods"
  services_cidr = "cilium-tf-prod-net-gke-services"
}

master_ipv4_cidr_block = "10.31.64.0/28"

master_authorized_networks = [
  {
    cidr_block   = "0.0.0.0/0"
    display_name = "internet"
  }
]

labels = {
  env      = "prod"
  customer = "portefaix"
  service  = "kubernetes"
  made-by  = "terraform"
}

network_policy             = false
auto_scaling               = true
hpa                        = true
pod_security_policy        = false
monitoring_service         = true
logging_service            = true
binary_authorization       = false
google_cloud_load_balancer = true
istio                      = false
cloudrun                   = false

maintenance_start_time = "05:00"

#####################################################################""
# Kubernetes node pool

node_pool_name = "core"
node_labels = {
  customer = "portefaix"
  env      = "prod"
  service  = "kubernetes"
  made-by  = "terraform"
}
node_tags = ["kubernetes", "node"]

node_count     = 1
min_node_count = 1
max_node_count = 2

machine_type = "n1-standard-4"
disk_size_gb = 100

auto_upgrade = true
auto_repair  = true

preemptible = true


############################################################################
# Firewall

source_ranges = [
  "10.0.0.0/20",
  "10.0.16.0/20", # Services
  "10.0.32.0/20"  # Pods
]
