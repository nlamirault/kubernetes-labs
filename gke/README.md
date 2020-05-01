# Portefaix on GKE

## GCloud

### berglas

VPC             | Services        | Pods            |
----------------|-----------------|-----------------|
10.10.0.0/20    | 10.10.16.0/20   | 10.10.32.0/20   |

### cilium

VPC             | Services        | Pods            |
----------------|-----------------|-----------------|
10.30.0.0/20    | 10.30.16.0/20   | 10.30.32.0/20   |

### knative

VPC             | Services        | Pods            |
----------------|-----------------|-----------------|
10.50.0.0/20    | 10.50.16.0/20   | 10.50.32.0/20   |


## Terraform

### cilium

VPC             | Services        | Pods            |
----------------|-----------------|-----------------|
10.0.0.0/20     | 10.0.16.0/20    | 10.0.32.0/20    |

### config-connector

* https://cloud.google.com/config-connector/docs/overview
* https://github.com/GoogleCloudPlatform/k8s-config-connector

VPC             | Services        | Pods            |
----------------|-----------------|-----------------|
10.20.0.0/20    | 10.20.16.0/20   | 10.20.32.0/20   |