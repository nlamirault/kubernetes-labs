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

resource "google_container_node_pool" "core" {
  provider = google-beta

  name       = var.node_pool_name
  location   = var.location
  cluster    = google_container_cluster.cluster.name
  node_count = var.node_count

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_upgrade = var.auto_upgrade
    auto_repair  = var.auto_repair
  }

  max_pods_per_node = 32

  node_config {
    image_type   = var.image_type
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    preemptible  = var.preemptible

    labels = var.node_labels
    tags   = var.node_tags

    workload_metadata_config {
      node_metadata = var.node_metadata
    }

    # metadata = (var.image_type == "UBUNTU" ? var.metadata_ubuntu : var.metadata_cos)

    # shielded_instance_config {
    #   enable_secure_boot          = var.shielded
    #   enable_integrity_monitoring = var.shielded
    # }

    service_account = var.service_account

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}
