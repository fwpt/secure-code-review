# ============================================================================
# CODE REVIEW SNIPPET 7: Dockerfile
# DO NOT USE - Contains insecure patterns!
# ============================================================================

FROM ubuntu:latest

MAINTAINER devops@company.com

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    nodejs \
    npm \
    vim \
    sudo

# Set working directory
WORKDIR /app

# Copy application files
COPY . /app

# Install Python dependencies
RUN pip3 install -r requirements.txt

# Install Node dependencies
RUN npm install

# Create application user
RUN useradd -m appuser && echo "appuser:password123" | chpasswd
RUN usermod -aG sudo appuser

# Set permissions
RUN chmod -R 777 /app

# Expose ports
EXPOSE 8080
EXPOSE 22
EXPOSE 3000

# Set environment variables
ENV DATABASE_URL=postgresql://admin:SuperSecret123@db.company.com:5432/production
ENV API_KEY=sk_live_abc123def456ghi789jkl
ENV DEBUG=true
ENV NODE_ENV=development

# Run as root
USER root

# Start application
CMD python3 app.py && npm start && /bin/bash
