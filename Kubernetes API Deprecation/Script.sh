#!/bin/bash
set -e

echo "➡️ Creating intentionally WRONG HPA manifest at ~/ckad-hpa.yaml (old API + deprecated field)..."

cat <<'YAML' > ~/ckad-hpa.yaml
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: web-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web-app
  minReplicas: 1
  maxReplicas: 5
  metrics:
    - type: Resource
      resource:
        name: cpu
        targetAverageUtilization: 70
YAML

echo "📄 Wrote the following (WRONG) manifest:"
