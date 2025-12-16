#!/bin/bash
set -e

echo "[+] Creating Pods with label app=store"

cat <<EOF > store-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: store-pod
  namespace: default
  labels:
    app: store
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
EOF

kubectl apply -f store-pod.yaml

echo "[+] Creating Service with WRONG selector"

cat <<EOF > store-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: store-svc
  namespace: default
spec:
  selector:
    WRONG: label
  ports:
  - port: 80
    targetPort: 80
EOF

kubectl apply -f store-svc.yaml

echo "[✓] Broken environment ready"
echo "Hint: kubectl get ep store-svc"
