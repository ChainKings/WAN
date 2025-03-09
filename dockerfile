FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-dev git wget ffmpeg libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Install PyTorch
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
RUN pip3 install easydict
# Clone and setup Wan2.1
WORKDIR /app
RUN git clone https://github.com/Wan-Video/Wan2.1.git
WORKDIR /app/Wan2.1

# Install core dependencies
RUN pip3 install --no-cache-dir transformers diffusers accelerate einops open-clip-torch moviepy sentencepiece
RUN pip3 install --no-cache-dir "xfuser>=0.4.1" "huggingface_hub[cli]" gradio

# Create model directory and expose port
RUN mkdir -p /app/models
EXPOSE 7860

# Setup entrypoint
COPY app/entrypoint.sh /app/
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]