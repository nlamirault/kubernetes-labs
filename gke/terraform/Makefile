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

APP = G K E / T E R R A F O R M

GCP_PROJECT=portefaix
GCP_TF_SA=terraform
GCP_TF_SA_EMAIL=$(GCP_TF_SA)@$(GCP_PROJECT).iam.gserviceaccount.com
GCP_CURRENT_PROJECT=$(shell gcloud info --format='value(config.project)')

KUBE_CONTEXT_preprod =
KUBE_CONTEXT_prod =
KUBE_CONTEXT = $(KUBE_CONTEXT_$(ENV))
KUBE_CURRENT_CONTEXT = $(shell kubectl config current-context)

CLUSTER_preprod =
CLUSTER_prod =
CLUSTER = $(CLUSTER_$(ENV))
REGION_preprod = europe-west1
REGION_prod = europe-west1
REGION = $(REGION_$(ENV))

SHELL = /bin/bash -o pipefail

DIR = $(shell pwd)

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m
INFO_COLOR=\033[36m
WHITE_COLOR=\033[1m

MAKE_COLOR=\033[33;01m%-20s\033[0m

.DEFAULT_GOAL := help

OK=[✅]
KO=[❌]
WARN=[⚠️]

.PHONY: help
help:
	@echo -e "$(OK_COLOR)                        $(APP)$(NO_COLOR)"
	@echo "------------------------------------------------------------------"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make ${INFO_COLOR}<target>${NO_COLOR}\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  ${INFO_COLOR}%-25s${NO_COLOR} %s\n", $$1, $$2 } /^##@/ { printf "\n${WHITE_COLOR}%s${NO_COLOR}\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo ""

# .PHONY: help
# help:
# 	@echo -e "$(OK_COLOR)==== $(APP) ====$(NO_COLOR)"
# 	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(MAKE_COLOR) : %s\n", $$1, $$2}'

guard-%:
	@if [ "${${*}}" = "" ]; then \
		echo -e "$(ERROR_COLOR)Environment variable $* not set$(NO_COLOR)"; \
		exit 1; \
	fi

check-%:
	@if $$(hash $* 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) $*"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) $*"; \
	fi

##@ Development

.PHONY: check
check: check-terraform check-gcloud ## Check requirements
	@if [[ "${GCP_PROJECT}" != "${GCP_CURRENT_PROJECT}" ]] ; then \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) ${GCP_CURRENT_PROJECT}"; \
	else \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) ${GCP_CURRENT_PROJECT}"; \
	fi

##@ GCloud

# ====================================
# G C L O U D
# ====================================

.PHONY: gcloud-project-switch
gcloud-project-switch: guard-GCP_PROJECT ## Switch GCP project
	gcloud config set project ${GCP_PROJECT}

.PHONY: gcloud-service-account
gcloud-service-account: ## Setup service account for Terraform
	@echo -e "$(INFO_COLOR)Create the service account$(NO_COLOR)"
	gcloud iam service-accounts create $(GCP_TF_SA) \
		--project $(GCP_PROJECT) --display-name $(GCP_TF_SA)

.PHONY: gcloud-bucket
gcloud-bucket: ## Setup the bucket for Terraform states
	@echo -e "$(INFO_COLOR)Create the service account$(NO_COLOR)"
	gsutil mb -p $(GCP_PROJECT) gs://portefaix-tfstates/

.PHONY: gcloud-kube-credentials
gcloud-kube-credentials: guard-ENV ## Generate credentials
	@gcloud container clusters get-credentials $(GCP_PROJECT)-$(ENV)-cluster-gke --region europe-west1 --project $(GCP_PROJECT)


##@ Terraform

# ====================================
# T E R R A F O R M
# ====================================


.PHONY: terraform-plan
terraform-plan: guard-SERVICE guard-ENV guard-GOOGLE_APPLICATION_CREDENTIALS ## Plan infrastructure (SERVICE=xxx ENV=xxx)
	@echo -e "$(OK_COLOR)[$(APP)] Plan infrastructure$(NO_COLOR)"
	@cd $(SERVICE) \
		&& terraform init -reconfigure -backend-config=backend-vars/$(ENV).tfvars \
		&& terraform plan -var-file=tfvars/$(ENV).tfvars

.PHONY: terraform-apply
terraform-apply: guard-SERVICE guard-ENV guard-GOOGLE_APPLICATION_CREDENTIALS ## Builds or changes infrastructure (SERVICE=xxx ENV=xxx)
	@echo -e "$(OK_COLOR)[$(APP)] Apply infrastructure$(NO_COLOR)"
	@cd $(SERVICE) \
		&& terraform init -reconfigure -backend-config=backend-vars/$(ENV).tfvars \
		&& terraform apply -var-file=tfvars/$(ENV).tfvars

