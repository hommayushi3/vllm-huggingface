# Set TGI like environment variables
NUM_SHARD=${NUM_SHARD:-$(nvidia-smi --list-gpus | wc -l)}
MODEL_PATH=${MODEL_PATH:-"/repository"}
MAX_MODEL_LEN=${MAX_MODEL_LEN:-1}
ENABLE_PREFIX_CACHING=${ENABLE_PREFIX_CACHING:-false}
DISABLE_SLIDING_WINDOW=${DISABLE_SLIDING_WINDOW:-false}
QUANTIZATION=${QUANTIZATION:-}
DTYPE=${DTYPE:-"auto"}
TRUST_REMOTE_CODE=${TRUST_REMOTE_CODE:-false}
GUIDED_DECODING_BACKEND=${GUIDED_DECODING_BACKEND:-"outlines"}

# Entrypoint for the OpenAI API server
CMD="vllm serve --host '0.0.0.0' --port 80 --model '$MODEL_PATH' --tensor-parallel-size '$NUM_SHARD' --dtype $DTYPE --guided-decoding-backend $GUIDED_DECODING_BACKEND"

# Append --max-model-len if its value is not -1
if [ "$MAX_MODEL_LEN" -ne -1 ]; then
    CMD="$CMD --max-model-len $MAX_MODEL_LEN"
fi
if [ "$ENABLE_PREFIX_CACHING" = true ]; then
    CMD="$CMD --enable-prefix-caching"
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

# Execute the command
eval $CMD
