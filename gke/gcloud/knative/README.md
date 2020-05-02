# Knative

* Create the cluster :

* Install Knative :

```shell
$ make kubernetes-build SERVICE=knative/1-namespaces ENV=prod

$ make kubernetes-apply SERVICE=knative/2-crds ENV=prod

$ make kubernetes-apply SERVICE=knative/3-operator ENV=prod

$ make kubernetes-apply SERVICE=knative/4-eventing ENV=prod

$ make kubernetes-apply SERVICE=knative/5-serving ENV=prod
```

* Check serving components :

```shell
$ kubectl -n knative-serving get pods
NAME                                READY   STATUS    RESTARTS   AGE
activator-8cb6d456-nmttv            2/2     Running   0          4m38s
autoscaler-dd459ddbb-g4x2c          2/2     Running   0          4m37s
autoscaler-hpa-687d76d9db-brvl4     2/2     Running   1          4m29s
controller-8564567c4c-7mv45         2/2     Running   1          4m36s
istio-webhook-5fcb47c757-q4xwf      2/2     Running   0          4m25s
networking-istio-5698886855-29w2r   1/1     Running   0          4m26s
webhook-7fbf9c6d49-xwbl9            2/2     Running   1          4m36s
```

* Check eventing components :

```shell
$ kubectl -n knative-eventing get pods
NAME                                    READY   STATUS      RESTARTS   AGE
broker-controller-bc6886b8f-7v8jl       1/1     Running     0          8m9s
broker-filter-5bb79b7d8b-s5hl6          1/1     Running     0          8m7s
broker-ingress-546f96f898-6kcnl         1/1     Running     0          8m7s
eventing-controller-6dcc6f58d9-jkhcl    1/1     Running     0          8m15s
eventing-webhook-78c58dcdbc-9gwzm       1/1     Running     0          8m14s
imc-controller-56dbcddbdd-kp2z5         1/1     Running     0          8m1s
imc-dispatcher-58d6644d79-m55zn         1/1     Running     0          8m1s
mt-broker-controller-7b8bcfc967-wggmb   1/1     Running     0          8m6s
v0.14.0-upgrade-mfdkp                   0/1     Completed   0          8m
```