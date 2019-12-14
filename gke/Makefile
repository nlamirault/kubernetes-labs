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

GCP_PROJECT=portefaix

CLUSTER_NAME=$(APP)-gcloud

GKE_SA=gke-gcloud-sa
GKE_SA_EMAIL=$(GKE_SA)@$(GCP_PROJECT).iam.gserviceaccount.com

GCP_CURRENT_PROJECT=$(shell gcloud info --format='value(config.project)')

SHELL = /bin/bash

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m
INFO_COLOR=\033[34;01m

MAKE_COLOR=\033[33;01m%-35s\033[0m

OK=[✅]
KO=[❌]
WARN=[⚠️]

.DEFAULT_GOAL := help

guard-%:
	@if [ "${${*}}" = "" ]; then \
		echo -e "$(ERROR_COLOR)Environment variable $* not set$(NO_COLOR)"; \
		exit 1; \
	fi

.PHONY: help
help:
	@echo -e "$(OK_COLOR)==== $(GCP_PROJECT) / GKE / GCloud ====$(NO_COLOR)"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(MAKE_COLOR) : %s\n", $$1, $$2}'


print-%:
	@if [ "${$*}" == "" ]; then \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) $* = ${$*}"; \
	else \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) $* = ${$*}"; \
	fi

.PHONY: gke-gcloud-check
gke-gcloud-check: ## Check requirements
	@if $$(hash gcloud 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) gcloud"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) gcloud"; \
	fi
	@if [[ "${GCP_PROJECT}" != "${GCP_CURRENT_PROJECT}" ]] ; then \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) ${GCP_CURRENT_PROJECT}"; \
	else \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) ${GCP_CURRENT_PROJECT}"; \
	fi


# ====================================
# G C L O U D
# ====================================


.PHONY: customer
customer:
	@echo -e "$(OK_COLOR)Load $(GCP_PROJECT) environment$(NO_COLOR)"
	echo -e "$(INFO_COLOR)GCP_PROJECT:$(NO_COLOR): ${GCP_PROJECT}"
	echo -e "$(INFO_COLOR)Nodes$(NO_COLOR): ${NUM_NODES} (${MIN_NODES} / ${MAX_NODES})"
	echo -e "$(INFO_COLOR)GCP$(NO_COLOR): region=${REGION} nodes=${NODE_LOCATIONS}"
	echo -e "$(INFO_COLOR)Machines$(NO_COLOR): ${MACHINE_TYPE}"
	echo -e "$(INFO_COLOR)Network / Subnetwork$(NO_COLOR): ${NETWORK} ${SUBNETWORK}:${SUBNETWORK_CIDR}"
	echo -e "$(INFO_COLOR)Services:$(NO_COLOR): ${SUBNETWORK_PODS_NAME} ${SUBNETWORK_PODS_CIDR}"
	echo -e "$(INFO_COLOR)Pods:$(NO_COLOR): ${SUBNETWORK_SVC_NAME} ${SUBNETWORK_SVC_CIDR}"
	echo -e "$(INFO_COLOR)K8S:$(NO_COLOR): ${CLUSTER_NAME} ${SUBNETWORK_SVC_CIDR}"


.SILENT:
.PHONY: gke-gcloud-project-current
gke-gcloud-project-current: ## Display current GCP project
	@gcloud info --format='value(config.project)'

.PHONY: gke-gcloud-check-project
gke-gcloud-check-project: guard-GCP_PROJECT
	@if [[ "${GCP_PROJECT}" != "${GCP_CURRENT_PROJECT}" ]] ; then \
		echo -e "$(ERROR_COLOR)[KO]$(NO_COLOR) GCP project: ${GCP_PROJECT} vs ${GCP_CURRENT_PROJECT}"; \
		exit 1; \
	fi

.PHONY: gke-gcloud-project-switch
gke-gcloud-project-switch: guard-GCP_PROJECT ## Switch GCP project
	gcloud config set project ${GCP_PROJECT}

.PHONY: gke-gcloud-project-setup
gke-gcloud-project-setup: guard-GCP_PROJECT  ## Setup GCloud project for Kubernetes
	@echo -e "$(INFO_COLOR)Setup project: ${GCP_PROJECT}$(NO_COLOR)"
	gcloud services enable iam.googleapis.com --project $(GCP_PROJECT)
	gcloud services enable cloudresourcemanager.googleapis.com --project $(GCP_PROJECT)
	gcloud services enable compute.googleapis.com --project $(GCP_PROJECT)
	gcloud services enable container.googleapis.com --project $(GCP_PROJECT)
	gcloud services enable containerregistry.googleapis.com --project $(GCP_PROJECT)
	gcloud iam service-accounts create $(GKE_SA) --project $(GCP_PROJECT) --display-name $(GKE_SA)
	gcloud projects add-iam-policy-binding $(GCP_PROJECT) --member serviceAccount:$(GKE_SA_EMAIL) --role roles/storage.admin --project $(GCP_PROJECT)
	gcloud projects add-iam-policy-binding $(GCP_PROJECT) --member serviceAccount:$(GKE_SA_EMAIL) --role roles/logging.logWriter --project $(GCP_PROJECT)
	gcloud projects add-iam-policy-binding $(GCP_PROJECT) --member serviceAccount:$(GKE_SA_EMAIL) --role roles/monitoring.metricWriter --project $(GCP_PROJECT)
	gcloud projects add-iam-policy-binding $(GCP_PROJECT) --member serviceAccount:$(GKE_SA_EMAIL) --role roles/container.admin --project $(GCP_PROJECT)

# .PHONY: gke-gcloud-project-setup
# gke-gcloud-project-vpc: guard-GCP_PROJECT ## Setup GCloud project for Kubernetes (ENV=xxx)
# 	@echo -e "$(INFO_COLOR)VPC for project: ${GCP_PROJECT}$(NO_COLOR)"
# 	gcloud compute networks peerings create $(GCP_PROJECT)-peering \
# 		--network $(NETWORK) \
# 		--peer-project $(CUSTOMER_GCP_PROJECT) \
# 		--peer-network vpc-$(CUSTOMER_GCP_PROJECT) \
# 		--auto-create-routes
# 	gcloud config set project $(CUSTOMER_GCP_PROJECT)
# 	gcloud compute networks peerings create $(CUSTOMER_GCP_PROJECT)-peering \
# 		--network vpc-$(CUSTOMER_GCP_PROJECT) \
# 		--peer-project $(GCP_PROJECT) \
# 		--peer-network $(NETWORK) \
# 		--auto-create-routes
# 	gcloud config set project ${GCP_PROJECT}
# 	gcloud compute networks peerings list


.PHONY: gke-gcloud-networks-create
gke-gcloud-networks-create: guard-GCP_PROJECT ## Create the networks and subnetworks
	@echo -e "$(INFO_COLOR)Setup networking for project: $(GCP_PROJECT)$(NO_COLOR)"
	# gcloud compute networks delete default --project $(GCP_PROJECT)
	gcloud compute networks create $(NETWORK) --subnet-mode custom --project $(GCP_PROJECT)
	gcloud compute networks subnets create $(SUBNETWORK) \
		--project $(GCP_PROJECT) \
		--network $(NETWORK) \
		--region $(REGION) \
		--range $(SUBNETWORK_CIDR) \
		--secondary-range ${SUBNETWORK_SVC_NAME}=$(SUBNETWORK_SVC_CIDR) \
		--secondary-range ${SUBNETWORK_PODS_NAME}=$(SUBNETWORK_PODS_CIDR)
	gcloud compute firewall-rules create allow-ssh \
		--network $(NETWORK) --allow tcp:22,tcp:3389,icmp

.PHONY: gke-gcloud-kubernetes-create
gke-gcloud-kubernetes-create: guard-GCP_PROJECT ## Create the Kubernetes cluster
	@echo -e "$(INFO_COLOR)Setup Kubernetes cluster for project: $(GCP_PROJECT)$(NO_COLOR)"
	gcloud beta container clusters create $(CLUSTER_NAME) \
		--project $(GCP_PROJECT) \
		--region $(REGION) \
		--node-locations $(NODE_LOCATIONS) \
		--machine-type $(MACHINE_TYPE) \
		--network $(NETWORK) --subnetwork $(SUBNETWORK) \
		$(CLUSTER_OPTIONS) \
		--num-nodes $(NUM_NODES) --min-nodes=$(MIN_NODES) --max-nodes=$(MAX_NODES) \
		--release-channel $(K8S_VERSION) \
		--image-type="COS" \
		--service-account $(GKE_SA_EMAIL) \
		--scopes=service-control,service-management,compute-rw,storage-ro,cloud-platform,logging-write,monitoring-write,pubsub,datastore

.PHONY: gke-gcloud-kubernetes-delete
gke-gcloud-kubernetes-delete: guard-GCP_PROJECT  ## Delete the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(GCP_PROJECT)] Delete Kubernetes cluster$(NO_COLOR)"
	@gcloud container clusters delete $(CLUSTER_NAME) \
		--project $(GCP_PROJECT) \
		--region $(REGION)

.PHONY: gke-gcloud-kubernetes-credentials
gke-gcloud-kubernetes-credentials: guard-GCP_PROJECT ## Retrieve the Kubernetes credentials
	@echo -e "$(OK_COLOR)[$(GCP_PROJECT)] Retrieve Kubernetes credentials$(NO_COLOR)"
	gcloud container clusters get-credentials $(CLUSTER_NAME) \
		--project $(GCP_PROJECT) \
		--region $(REGION)
	kubectl create clusterrolebinding cluster-admin-binding \
		--clusterrole=cluster-admin \
		--user=$(gcloud config get-value core/account)

.PHONY: gke-gcloud-kubernetes-maintenance
gke-gcloud-kubernetes-maintenance: ## Configure a maintenance window
	@echo -e "$(OK_COLOR)[$(GCP_PROJECT)] Add exclusion for maintenance window$(NO_COLOR)"
	gcloud beta container clusters update $(CLUSTER_NAME) \
		--project $(GCP_PROJECT) \
		--region $(REGION) \
		--add-maintenance-exclusion-name black-friday \
		--add-maintenance-exclusion-start 2019-11-29T00:00:00-05:00 \
		--add-maintenance-exclusion-end 2019-12-02T23:59:59-07:00