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

resource "google_service_account" "main" {
  account_id   = "cnrm-system"
  display_name = "Config Connector"
  description  = "Created by Terraform"
}

resource "google_service_account_iam_member" "cnrm-system-iam" {
  service_account_id = google_service_account.main.name
  role               = "roles/owner"
  member             = format("serviceAccount:%s", google_service_account.main.email)
}

resource "google_service_account_iam_binding" "cnrm-controller-manager-iam" {
  service_account_id = google_service_account.main.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:[PROJECT_ID].svc.id.goog[cnrm-system/cnrm-controller-manager]",
  ]
}
