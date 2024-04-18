################## KUBESTELLAR v0.14 EXPERIMENTS ########################################
# PREREQUISITE: create a context for WMW1 space by running the following commands
#   >> KUBECONFIG=path/kind-sdf-ks kubectl ws root:wmw1  (kind-sdf-ks: it's your kubestellar kubeconfig)
#   >> KUBECONFIG=path/kind-sdf-ks kubectl kcp workspace create-context

mypath="exp-sdf/"
namespace="sharpeningcloudcomputepod"
kubeconfig_core="ks-core.kubeconfig" #  Kubestellar core kubeconfig
kubeconfig_wec="ks-wec.kubeconfig"  # WEC kubeconfig (e.g., k3s/RPi)

python3 object_timestamp_collector.py  $kubeconfig_core "root:wmw1"  "pod"  ""  ""  ""  $namespace "$mypath/sdf-app-kscore.txt"
echo "Done collecting App data from WDS ..."

python3 object_timestamp_collector.py  $kubeconfig_wec  ""  "pod"  ""  ""  "" $namespace "$mypath/sdf-app-wec.txt"
echo "Done collecting App data from WEC cluster ..."
