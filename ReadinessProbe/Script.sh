#!/bin/bash
set -e

echo "[+] Creating nginx Deployment WITHOUT readinessProbe"

cat <<EOF > nginx-deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
EOF

kubectl apply -f nginx-deploy.yaml

echo "[✓] Environment ready"
echo "Task: Add readinessProbe to nginx container (do not change anything else)"
