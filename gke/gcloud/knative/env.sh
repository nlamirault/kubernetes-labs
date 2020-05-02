#!/bin/bash

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

export PROJECT_NAME="knative"
export ENV="prod"
export APP=${PROJECT_NAME}-gcloud-${ENV}

export REGION="europe-west1"
export NODE_LOCATIONS="europe-west1-c,europe-west1-d"

export MACHINE_TYPE="n1-standard-2"

export NETWORK="${APP}"
export SUBNETWORK="${APP}-net"
export SUBNETWORK_CIDR="10.50.0.0/20"
export SUBNETWORK_SVC_NAME="${APP}-gke-svc"
export SUBNETWORK_SVC_CIDR="10.50.16.0/20"
export SUBNETWORK_PODS_NAME="${APP}-gke-pods"
export SUBNETWORK_PODS_CIDR="10.50.32.0/20"

export NUM_NODES="1"
export MIN_NODES="2"
export MAX_NODES="3"

# Kubernetes version to deploy
# https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels
export K8S_VERSION="regular"

COMMONS_OPTIONS="--enable-autoscaling --enable-autoupgrade --enable-intra-node-visibility --enable-stackdriver-kubernetes"
MAINTENANCE_OPTIONS="--maintenance-window 3:00"
NETWORK_OPTIONS="--enable-ip-alias --cluster-secondary-range-name=${SUBNETWORK_PODS_NAME} --services-secondary-range-name=${SUBNETWORK_SVC_NAME}"
KNATIVE_OPTIONS="--addons=HorizontalPodAutoscaling,HttpLoadBalancing,Istio"
# PRIVATE_GKE_OPTIONS="--enable-private-endpoint --enable-private-nodes --master-ipv4-cidr=${IPV4_CIDR_GKE_MASTER}"
export CLUSTER_OPTIONS="${COMMONS_OPTIONS} ${NETWORK_OPTIONS} ${MAINTENANCE_OPTIONS} ${KNATIVE_OPTIONS} "

