FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-dev git wget ffmpeg libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Set Python3 as default
RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

# Install PyTorch with CUDA support
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir torch==2.2.0 torchvision==0.17.0 --extra-index-url https://download.pytorch.org/whl/cu121

# Clone Wan2.1 repository
WORKDIR /app
RUN git clone https://github.com/Wan-Video/Wan2.1.git
WORKDIR /app/Wan2.1

# Install core dependencies with specific version constraints
RUN pip install --no-cache-dir "numpy<2.0.0" # Ensure NumPy 1.x compatibility
RUN pip install --no-cache-dir transformers diffusers accelerate einops open-clip-torch moviepy sentencepiece ftfy
RUN pip install --no-cache-dir xfuser huggingface_hub gradio easydict

# Create model directory
RUN mkdir -p /app/models
EXPOSE 7860

# Copy entrypoint script
COPY entrypoint.sh /app/
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]