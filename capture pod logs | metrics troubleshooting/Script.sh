#Task 1

#!/bin/bash

echo "[+] Creating namespace cpu-stress..."
kubectl create namespace cpu-stress --dry-run=client -o yaml | kubectl apply -f -

echo "[+] Creating stress pods..."
cat <<EOF | kubectl apply -n cpu-stress -f -
apiVersion: v1
kind: Pod
metadata:
  name: stress-1
spec:
  containers:
  - name: c1
    image: busybox
    command: ["sh", "-c", "while true; do :; done"]

---
apiVersion: v1
kind: Pod
metadata:
  name: stress-2
spec:
  containers:
  - name: c1
    image: busybox
    command: ["sh", "-c", "while true; do usleep 50000; done"]
EOF

echo "[+] Installing Metrics Server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo "[+] Patching Metrics Server to allow insecure TLS..."
kubectl patch deployment metrics-server -n kube-system \
  --type='json' \
  -p='[
        {"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"},
        {"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname"}
      ]'

echo "[+] Waiting for Metrics Server to stabilize..."
sleep 10

echo "[+] Script complete!"
echo "Run this to verify metrics:"
echo "  kubectl top pods -n cpu-stress"
