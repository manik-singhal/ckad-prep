#!/usr/bin/env bash
set -euo pipefail

# Prepare directory
mkdir -p "$HOME/broker-deployment"
MANIFEST="$HOME/broker-deployment/hotfix-deployment.yaml"

# Create Deployment manifest with NO securityContext anywhere
cat > "$MANIFEST" <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hotfix-deployment
  namespace: quetzal
  labels:
    app: hotfix
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hotfix
  template:
    metadata:
      labels:
        app: hotfix
    spec:
      containers:
        - name: hotfix-container
          image: nginx:stable
          ports:
            - containerPort: 80
EOF

echo "[OK] Created manifest: $MANIFEST"

# Ensure namespace exists
kubectl create namespace quetzal --dry-run=client -o yaml | kubectl apply -f -

# Apply the Deployment
kubectl apply -f "$MANIFEST"

echo
echo "=== Environment ready ==="
echo "Deployment created WITHOUT any securityContext."
echo
echo "You can now perform the required edits:"
echo "  kubectl edit deployment hotfix-deployment -n quetzal"
echo
echo "And add under containers[0]:"
echo "      securityContext:"
echo "        runAsUser: 3000"
echo "        allowPrivilegeEscalation: false"
echo
echo "Verify afterwards using:"
echo "  kubectl -n quetzal get deploy hotfix-deployment -o yaml"
echo
