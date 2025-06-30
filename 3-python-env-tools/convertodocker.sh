#!/bin/bash
# convertodocker.sh - Quickly dockerize any Python project

PROJECT_DIR="$1"

if [ -z "$PROJECT_DIR" ]; then
    echo "❌ Usage: ./convertodocker.sh <project_directory>"
    exit 1
fi

if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Directory not found: $PROJECT_DIR"
    exit 1
fi

SCRIPT_DIR=$(dirname "$0")

echo "📦 Detecting requirements for $PROJECT_DIR..."
python3 "$SCRIPT_DIR/detect-reqs.py" "$PROJECT_DIR" > "$PROJECT_DIR/requirements.txt"

echo "📁 Copying Dockerfile template..."
cp "$SCRIPT_DIR/Dockerfile.template" "$PROJECT_DIR/Dockerfile"

read -p "🛠️  Build Docker image now? (y/n): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    IMAGE_NAME=$(basename "$PROJECT_DIR")
    echo "🐳 Building Docker image: $IMAGE_NAME"
    docker build -t "$IMAGE_NAME" "$PROJECT_DIR"

    echo "🚀 Run the image with:"
    echo "    docker run --rm $IMAGE_NAME"
else
    echo "✅ Dockerfile ready at $PROJECT_DIR. You can build later with:"
    echo "    docker build -t <imagename> $PROJECT_DIR"
fi
