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

#############################################################################
# Provider

variable project {
  type        = string
  description = "The project in which the resource belongs"
}

variable location {
  type        = string
  description = "The location linked to the project"
}

#############################################################################
# Kubernetes cluster

variable network {
  type        = string
  description = "Name of the network to use"
}

variable subnet_network {
  type        = string
  description = "Name of the subnet to use"
}

variable name {
  description = "Cluster name"
  type        = string
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
}

variable labels {
  description = "List of Kubernetes labels to apply to the nodes"
  type        = map
}

variable rbac_group_domain {
  description = "Google Groups for RBAC requires a G Suite domain"
  type        = string
  default     = ""
}

variable network_policy {
  description = "Enable Network Policy"
  type        = bool
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
  description = "Time window specified for daily maintenance operations in RFC3339 format"
  type        = string
  default     = "03:00"
}

variable auto_scaling_max_cpu {
  type        = number
  description = ""
  default     = 10
}

variable auto_scaling_min_cpu {
  type        = number
  description = ""
  default     = 5
}

variable auto_scaling_max_mem {
  type        = number
  description = ""
  default     = 20
}

variable auto_scaling_min_mem {
  type        = number
  description = ""
  default     = 5
}


#############################################################################
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
  default     = 3
}

variable max_node_count {
  type        = number
  description = "Maxiumum number of nodes in the NodePool."
  default     = 6
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

variable service_account {
  type        = string
  description = "The Google Cloud Platform Service Account to be used by the node VMs"
  default     = "default"
}

variable image_type {
  type        = string
  description = "The image type to use for this node"
  default     = "COS"
}

variable machine_type {
  type        = string
  description = "The name of a Google Compute Engine machine type"
}

variable disk_size_gb {
  type        = number
  description = "Size of the disk attached to each node"
  default     = 100
}

variable preemptible {
  type        = bool
  description = "Whether the node VMs are preemptible"
}

variable node_labels {
  type        = map
  description = "The Kubernetes labels (key/value pairs) to be applied to each node"
}

variable node_tags {
  type        = list
  description = "The list of instance tags applied to all nodes"
}
