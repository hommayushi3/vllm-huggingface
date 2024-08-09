from huggingface_hub import create_inference_endpoint
import os
from dotenv import load_dotenv


VLLM_HF_IMAGE_URL = "hommayushi3/vllm-huggingface"


if __name__ == "__main__":
    load_dotenv()
    repo_id = "microsoft/Phi-3-vision-128k-instruct"
    env_vars = {
        "MAX_MODEL_LEN": "3072",
        "DISABLE_SLIDING_WINDOW": "true",
        "DTYPE": "bfloat16",
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
