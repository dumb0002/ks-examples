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
