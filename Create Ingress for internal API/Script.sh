#!/bin/bash
set -e

echo "[+] Creating internal-api Deployment"

cat <<EOF > internal-api-deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: internal-api
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: internal-api
  template:
    metadata:
      labels:
        app: internal-api
    spec:
      containers:
      - name: internal-api
        image: nginx
        ports:
        - containerPort: 80
EOF

kubectl apply -f internal-api-deploy.yaml

echo "[+] Creating internal-api-svc Service exposing port 3000"

cat <<EOF > internal-api-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: internal-api-svc
  namespace: default
spec:
  selector:
    app: internal-api
  ports:
  - port: 3000
    targetPort: 80
EOF

kubectl apply -f internal-api-svc.yaml

echo "[✓] Environment ready"
