FROM node:20-slim

LABEL maintainer="OpenClaw Community"
LABEL version="1.0.0"

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    ca-certificates \
    python3 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash openclaw && \
    mkdir -p /home/openclaw/.openclaw && \
    chown -R openclaw:openclaw /home/openclaw

# Set working directory
WORKDIR /workspace

# Set environment
ENV NODE_ENV=production \
    OPENCLAW_HOME=/home/openclaw/.openclaw

# Switch to non-root user
USER openclaw

# Default command
CMD ["openclaw", "gateway", "start"]
