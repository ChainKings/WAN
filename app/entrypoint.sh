#!/bin/bash
# entrypoint.sh

# Download model if not already present
if [ ! -d "/app/models/Wan2.1-T2V-1.3B" ]; then
  echo "Downloading Wan2.1-T2V-1.3B model..."
  python3 -c "
  from huggingface_hub import snapshot_download
  snapshot_download(repo_id='Wan-AI/Wan2.1-T2V-1.3B', local_dir='/app/models/Wan2.1-T2V-1.3B')
  "
fi

# Start Gradio interface
cd /app/Wan2.1/gradio
python3 t2v_14B_singleGPU.py --ckpt_dir /app/models/Wan2.1-T2V-1.3B --server_port 7860 --server_name 0.0.0.0