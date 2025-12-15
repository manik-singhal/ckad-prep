#!/bin/bash

set -e

echo "[+] Creating billing-api deployment with hard-coded env vars"

cat <<EOF > billing-api.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: billing-api
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: billing-api
  template:
    metadata:
      labels:
        app: billing-api
    spec:
      containers:
      - name: billing-api
        image: nginx
        env:
        - name: DB_USER
          value: admin
        - name: DB_PASS
          value: password123
EOF

kubectl apply -f billing-api.yaml

echo "[✓] billing-api deployment created in default namespace"
