#!/bin/bash

# OpenClaw Basic Installation Test
# Test Round 1: Basic installation verification

set -e

echo "========================================="
echo "OpenClaw Installation Test - Round 1"
echo "========================================="

# Test 1: Check if OpenClaw is installed
echo "[1/5] Checking OpenClaw installation..."
if command -v openclaw &> /dev/null; then
    echo "✓ OpenClaw command found"
    openclaw --version
else
    echo "✗ OpenClaw not found in PATH"
    exit 1
fi

# Test 2: Check Node.js version
echo "[2/5] Checking Node.js version..."
NODE_VERSION=$(node --version)
echo "Node.js version: $NODE_VERSION"
if [[ "$NODE_VERSION" =~ ^v[0-9]+ ]]; then
    echo "✓ Node.js version OK"
else
    echo "✗ Node.js version check failed"
    exit 1
fi

# Test 3: Check configuration directory
echo "[3/5] Checking config directory..."
if [ -d "$HOME/.openclaw" ]; then
    echo "✓ OpenClaw config directory exists"
    ls -la "$HOME/.openclaw"
else
    echo "✗ OpenClaw config directory not found"
    exit 1
fi

# Test 4: Run openclaw doctor
echo "[4/5] Running OpenClaw doctor..."
if openclaw doctor 2>&1 | tee /tmp/openclaw-doctor.log; then
    echo "✓ OpenClaw doctor passed"
else
    echo "✗ OpenClaw doctor reported issues"
    cat /tmp/openclaw-doctor.log
fi

# Test 5: Check gateway status
echo "[5/5] Checking gateway status..."
if openclaw gateway status &> /dev/null; then
    echo "✓ Gateway is running"
else
    echo "⚠ Gateway not running (may need configuration)"
fi

echo ""
echo "========================================="
echo "Test Round 1 Complete"
echo "========================================="
