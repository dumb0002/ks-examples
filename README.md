# ks-examples

To start proceed as following:

1. Configure the following parameters in the `./run-data-colletor.sh` script:

```
mypath="exp-sdf/" # Directory to store the output file
namespace="sdf" # Namespace for your workload
kubeconfig_core="ks-core.kubeconfig" #  Kubestellar core kubeconfig
kubeconfig_wec="ks-wec.kubeconfig"  # WEC kubeconfig (e.g., k3s/RPi)
```

2. Run the metrics collection script:

```
./run-data-colletor.sh
```

The output is a file with the following structure:

```
<obj_name> <obj_creation_time> <obj_status_update_time> <obj_status_condition> <obj_controller_manager>
```

For example: 

```
pod-sample	2024-04-14 20:51:19+00:00	2024-04-14 20:51:44+00:00	Running  controller-manager
```

## Set-up Kubernetes horizontal pod autoscaling for a deployment:

The Kubernetes Horizontal Pod Autoscaler (HPA) automatically scales the number of pods in a deployment based on a custom metric or a resource metric from a pod using the Metrics Server. For example, if there is a sustained spike in CPU use over 80%, then the HPA deploys more pods to manage the load across more resources, maintaining application performance. 

Let's use an ngnix deployment as an example of how to configure HPA:

1. Install the k8s metrics server:

```
$ kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

2. Edit the metrics server deployment with this - --kubelet-insecure-tls to args list:

```
$ kubectl -n kube-system edit deploy metrics-server
```

Add the flag `--kubelet-insecure-tls` as in the example below: 

```
...
labels:
    k8s-app: metrics-server
spec:
  containers:
  - args:
    - --cert-dir=/tmp
    - --secure-port=443
    - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
    - --kubelet-use-node-status-port
    - --metric-resolution=15s
    - --kubelet-insecure-tls # add this line
...
```

3. Check that the metrics server deployment is running:

```
$ kubectl get deployment metrics-server -n kube-system
```

3. Deploy your sample application:

```
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/nginx-deployment.yaml
```

4. Set up horizontal pod autoscaling:

```
$ kubectl autoscale deployment nginx-deployment --cpu-percent=80 --min=1 --max=4
```

This will increase pods to a maximum of four replicas (--max=4) when the nginx application experiences more than 80% CPU use (--cpu-percent=80) over a sustained period. 

5. To check the status of Horizontal Pod Autoscaler:

Initially, you might observe an unknown value in the current state, as it takes some time to pull metrics from the Metrics Server and generate the percentage use.

```
kubectl get hpa
NAME               REFERENCE                     TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
nginx-deployment   Deployment/nginx-deployment   <unknown>/80%   1         4         1          18m
```

For a detailed status of the Horizontal Pod Autoscaler, use the `describe` command to find details such as metrics, events and conditions.
