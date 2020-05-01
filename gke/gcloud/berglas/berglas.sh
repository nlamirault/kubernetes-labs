#!/usr/bin/env bash

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

export PROJECT_ID="portefaix"

export BUCKET_ID="portefaix-berglas"
export BUCKET_LOCATION="europe-west1"

export BERGLAS_KEYRING="berglas"

export BERGLAS_KEY="berglas"

gcloud auth application-default login

gcloud kms keyrings create ${BERGLAS_KEYRING} \
    --project ${PROJECT_ID} \
    --location global

gcloud kms keys create ${BERGLAS_KEY} \
  --project ${PROJECT_ID} \
  --location global \
  --keyring ${BERGLAS_KEYRING} \
  --purpose encryption

gsutil mb -p ${PROJECT_ID} gs://${BUCKET_ID}
gsutil defacl set private gs://${BUCKET_ID}
gsutil acl set private gs://${BUCKET_ID}

# berglas bootstrap \
#     --project ${PROJECT_ID} \
#     --bucket ${BUCKET_ID} \
#     --bucket-location ${BUCKET_LOCATION}

berglas create ${BUCKET_ID}/portefaix-secret "a-secret-manage-by-berglas" \
  --key projects/${PROJECT_ID}/locations/global/keyRings/berglas/cryptoKeys/${BERGLAS_KEY}