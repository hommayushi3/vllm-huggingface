from huggingface_hub import create_inference_endpoint
import os
from dotenv import load_dotenv


VLLM_HF_IMAGE_URL = "hommayushi3/vllm-huggingface"


if __name__ == "__main__":
    load_dotenv()
    repo_id = "microsoft/Phi-3.5-vision-instruct"
    env_vars = {
        "DISABLE_SLIDING_WINDOW": "true",
        "MAX_MODEL_LEN": "2048",
        "MAX_NUM_BATCHED_TOKENS": "8192",
        "DTYPE": "bfloat16",
        "GPU_MEMORY_UTILIZATION": "0.98",
        "QUANTIZATION": "fp8",
        "USE_V2_BLOCK_MANAGER": "true",
        "VLLM_ATTENTION_BACKEND": "FLASH_ATTN",
        "TRUST_REMOTE_CODE": "true",
    }

    endpoint = create_inference_endpoint(
        name=os.path.basename(repo_id).lower(),
        repository=repo_id,
        framework="pytorch",
        task="custom",
        accelerator="gpu",
        vendor="aws",
        region="us-east-1",
        type="protected",
        instance_size="x1",
        instance_type="nvidia-l4",
        custom_image={
            "health_route": "/health",
            "env": env_vars,
            "url": VLLM_HF_IMAGE_URL,
        },
        token=os.getenv("HF_TOKEN"),
    )
    
    print(f"Go to https://ui.endpoints.huggingface.co/{endpoint.namespace}/endpoints/{endpoint.name} to see the endpoint status.")
