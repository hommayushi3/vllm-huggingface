FROM vllm/vllm-openai:v0.5.5


ENV VLLM_COMMIT=8aaf3d5347ad536de25869caa67b90e43f1ccd5b
ENV VLLM_VERSION=0.5.5
ENV DO_NOT_TRACK=1

COPY --chmod=775 endpoints-entrypoint.sh entrypoint.sh

RUN pip uninstall -y vllm && \
    pip install https://vllm-wheels.s3.us-west-2.amazonaws.com/${VLLM_COMMIT}/vllm-${VLLM_VERSION}-cp38-abi3-manylinux1_x86_64.whl

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
CMD [""]
