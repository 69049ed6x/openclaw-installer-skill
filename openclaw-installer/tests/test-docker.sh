#!/bin/bash

# OpenClaw Docker Test Script
# Test Round 2 & 3: Docker-specific tests

set -e

CONTAINER_NAME="openclaw-test"
IMAGE_NAME="openclaw/openclaw:latest"

echo "========================================="
echo "OpenClaw Docker Test - Round 2/3"
echo "========================================="

# Pre-test: Stop any existing container
echo "[Setup] Cleaning up existing containers..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Test 1: Pull latest image
echo "[1/6] Pulling OpenClaw Docker image..."
docker pull $IMAGE_NAME
echo "✓ Image pulled successfully"

# Test 2: Run container
echo "[2/6] Starting OpenClaw container..."
docker run -d \
  --name $CONTAINER_NAME \
  -p 18789:18789 \
  -e ANTHROPIC_API_KEY="test-key" \
  $IMAGE_NAME

# Wait for container to start
echo "[3/6] Waiting for container to initialize..."
sleep 10

# Test 3: Check container status
echo "[3/6] Checking container status..."
CONTAINER_STATUS=$(docker inspect -f '{{.State.Status}}' $CONTAINER_NAME)
if [ "$CONTAINER_STATUS" == "running" ]; then
    echo "✓ Container is running"
else
    echo "✗ Container status: $CONTAINER_STATUS"
    docker logs $CONTAINER_NAME
    exit 1
fi

# Test 4: Check port mapping
echo "[4/6] Checking port mapping..."
if docker port $CONTAINER_NAME | grep -q "18789"; then
    echo "✓ Port 18789 is mapped"
else
    echo "✗ Port mapping failed"
    exit 1
fi

# Test 5: Check logs for errors
echo "[5/6] Checking logs for errors..."
LOGS=$(docker logs $CONTAINER_NAME 2>&1)
if echo "$LOGS" | grep -qi "error\|fatal\|exception"; then
    echo "⚠ Warning: Potential errors found in logs"
    echo "$LOGS" | tail -20
else
    echo "✓ No obvious errors in logs"
fi

# Test 6: Cleanup
echo "[6/6] Cleaning up..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
echo "✓ Container cleaned up"

echo ""
echo "========================================="
echo "Docker Test Complete"
echo "========================================="
