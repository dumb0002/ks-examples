from kshelper import *
import sys

kubeconfig = sys.argv[1]
context = sys.argv[2]
kind = sys.argv[3]
obj_grp = sys.argv[4]
obj_v = sys.argv[5]
obj_pl = sys.argv[6]
obj_ns = sys.argv[7]
outfile = sys.argv[8]


c = Collector(kubeconfig, context, outfile)

if kind == "crd":    
    c.get_crd_time(obj_grp, obj_v, obj_pl)
    print("Completed collecting CRD metrics from target cluster ...")

elif kind == "pod":
    c.get_pod_time(obj_ns)
    print("Completed collecting Pod metrics from target cluster ...")

else:
    print("Not supported type ....")
