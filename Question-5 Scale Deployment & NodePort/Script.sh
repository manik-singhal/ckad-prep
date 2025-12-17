#!/bin/bash

# Create namespace
kubectl create ns nov2025

# Create deployment manifest using dry-run
kubectl create deploy nov2025-deployment \
  --image=nginx \
  -n nov2025 

# Execution complete!  
