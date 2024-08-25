# Set TGI like environment variables
NUM_SHARD=${NUM_SHARD:-$(nvidia-smi --list-gpus | wc -l)}
MODEL_PATH=${MODEL_PATH:-"/repository"}
MAX_MODEL_LEN=${MAX_MODEL_LEN:-1}
MAX_NUM_BATCHED_TOKENS=${MAX_NUM_BATCHED_TOKENS:-1}
ENABLE_CHUNKED_PREFILL=${ENABLE_CHUNKED_PREFILL:-false}
ENABLE_PREFIX_CACHING=${ENABLE_PREFIX_CACHING:-false}
DISABLE_SLIDING_WINDOW=${DISABLE_SLIDING_WINDOW:-false}
QUANTIZATION=${QUANTIZATION:-}
DTYPE=${DTYPE:-"auto"}
TRUST_REMOTE_CODE=${TRUST_REMOTE_CODE:-false}
GUIDED_DECODING_BACKEND=${GUIDED_DECODING_BACKEND:-"outlines"}
KV_CACHE_DTYPE=${KV_CACHE_DTYPE:-"auto"}
ENFORCE_EAGER=${ENFORCE_EAGER:-false}
USE_V2_BLOCK_MANAGER=${USE_V2_BLOCK_MANAGER:-false}
VLLM_ATTENTION_BACKEND=${VLLM_ATTENTION_BACKEND:-"FLASH_ATTN"}
GPU_MEMORY_UTILIZATION=${GPU_MEMORY_UTILIZATION:-0.9}


# Entrypoint for the OpenAI API server
CMD="vllm serve $MODEL_PATH --host '0.0.0.0' --port 80 --tensor-parallel-size '$NUM_SHARD'"
CMD="$CMD --dtype $DTYPE --guided-decoding-backend $GUIDED_DECODING_BACKEND --kv-cache-dtype $KV_CACHE_DTYPE"
CMD="$CMD --gpu-memory-utilization $GPU_MEMORY_UTILIZATION"

# Append --max-model-len if its value is not -1
if [ "$MAX_MODEL_LEN" -ne 1 ]; then
    CMD="$CMD --max-model-len $MAX_MODEL_LEN"
fi
if [ "$MAX_NUM_BATCHED_TOKENS" -ne 1 ]; then
    CMD="$CMD --max-num-batched-tokens $MAX_NUM_BATCHED_TOKENS"
fi
if [ "$ENABLE_PREFIX_CACHING" = true ]; then
    CMD="$CMD --enable-prefix-caching"
fi
if [ "$ENABLE_CHUNKED_PREFILL" = true ]; then
    CMD="$CMD --enable-chunked-prefill"
fi
if [ "$DISABLE_SLIDING_WINDOW" = true ]; then
    CMD="$CMD --disable-sliding-window"
fi
if [ -n "$QUANTIZATION" ]; then
    CMD="$CMD --quantization $QUANTIZATION"
fi
if [ "$TRUST_REMOTE_CODE" = true ]; then
    CMD="$CMD --trust-remote-code"
fi
if [ "$ENFORCE_EAGER" = true ]; then
    CMD="$CMD --enforce-eager"
fi
if [ "$USE_V2_BLOCK_MANAGER" = true ]; then
    CMD="$CMD --use-v2-block-manager"
fi

# Execute the command
eval $CMD
