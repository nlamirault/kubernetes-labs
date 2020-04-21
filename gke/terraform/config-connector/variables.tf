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

variable project {
  type        = string
  description = "The project in which the resource belongs"
}

variable location {
  type        = string
  description = "The location linked to the project"
}


############################################################################
# VPC

variable customer {}

variable env {}

variable range {}

variable gke_services_subnet_cidr {}

variable gke_pods_subnet_cidr {}


############################################################################
# Kubernetes

variable name {
  description = "Cluster name"
  type        = string
}

variable network {
  type        = string
  description = "Name of the network to use"
}

variable subnet_network {
  type        = string
  description = "Name of the subnet to use"
}

variable release_channel {
  description = "Release cadence of the GKE cluster"
  type        = string
}

variable network_config {
  description = "VPC network configuration for the cluster"
  type        = map
}

variable master_ipv4_cidr_block {
  type = string
}

variable "master_authorized_networks" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "List of master authorized networks"
  # default = [
  #   {
  #     cidr_block   = "0.0.0.0/0"
  #     display_name = "internet"
  #   }
  # ]
}

variable labels {
  description = "List of Kubernetes labels to apply to the nodes"
  type        = map
}

variable tags {
  description = "The list of instance tags applied to all nodes."
  type        = list
  default     = []
}

variable rbac_group_domain {
  description = "Google Groups for RBAC requires a G Suite domain"
  type        = string
  default     = ""
}

variable network_policy {
  description = "Enable Network Policy"
  type        = bool
  default     = true
}

variable auto_scaling {
  description = "Enable cluster autoscaling"
  type        = bool
}

variable hpa {
  description = "Enable Horizontal Pod Autoscaling"
  type        = bool
}

variable pod_security_policy {
  description = "Enable Pod Security Policy"
  type        = bool
  default     = true
}

variable monitoring_service {
  description = "Enable monitoring Service"
  type        = bool
  default     = true
}

variable logging_service {
  description = "Enable logging Service"
  type        = bool
  default     = true
}

variable binary_authorization {
  description = "Enable Binary Authorization"
  type        = bool
  default     = true
}

variable google_cloud_load_balancer {
  description = "Enable Google load balancer"
  type        = bool
}

variable istio {
  description = "Enable Istio"
  type        = bool
}

variable cloudrun {
  description = "Enable Cloud Run on GKE (requires istio)"
  type        = bool
}

variable maintenance_start_time {
  description = ""
  type        = string
  default     = "03:00"
}

#####################################################################""
# Kubernetes node pool

variable node_pool_name {
  description = "Node pool name"
  type        = string
}

variable node_count {
  type        = number
  description = "The number of nodes per instance group"
}

variable min_node_count {
  type        = number
  description = "Minimum number of nodes in the NodePool."
}

variable max_node_count {
  type        = number
  description = "Maxiumum number of nodes in the NodePool."
}

variable machine_type {
  type        = string
  description = "The name of a Google Compute Engine machine type"
}

variable image_type {
  default = "COS"
}

variable disk_size_gb {
}

variable preemptible {
}

variable node_labels {
}

variable node_tags {
}

variable auto_upgrade {
  type        = bool
  description = "Whether the nodes will be automatically upgraded"
}

variable auto_repair {
  type        = bool
  description = "Whether the nodes will be automatically repaired"
}

variable node_metadata {
  type        = string
  description = "How to expose the node metadata to the workload running on the node."
  default     = "GKE_METADATA_SERVER"
}


############################################################################
# Firewall

variable source_ranges {
  type = list
}
