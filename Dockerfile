FROM vllm/vllm-openai:v0.5.5


ENV VLLM_COMMIT=80162c44b1d1e59a2c10f65b6adb9b0407439b1f
ENV VLLM_VERSION=0.5.5
ENV DO_NOT_TRACK=1

COPY --chmod=775 endpoints-entrypoint.sh entrypoint.sh

RUN pip uninstall -y vllm && \
    pip install https://vllm-wheels.s3.us-west-2.amazonaws.com/${VLLM_COMMIT}/vllm-${VLLM_VERSION}-cp38-abi3-manylinux1_x86_64.whl

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
CMD [""]
