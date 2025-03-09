FROM pytorch/pytorch:2.4.0-cuda12.1-cudnn8-runtime

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    ffmpeg \
    libgl1-mesa-glx \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Clone Wan2.1 repository
WORKDIR /app
RUN git clone https://github.com/Wan-Video/Wan2.1.git
WORKDIR /app/Wan2.1

# Install Python dependencies
RUN pip install -r requirements.txt
RUN pip install "xfuser>=0.4.1" "huggingface_hub[cli]" gradio
RUN pip install flash-attn --no-build-isolation

# Set up model directory
RUN mkdir -p /app/models

# Expose port for Gradio
EXPOSE 7860

# Set entrypoint script
COPY entrypoint.sh /app/
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]