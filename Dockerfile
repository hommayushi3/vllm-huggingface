FROM vllm/vllm-openai:v0.6.4.post1


ENV VLLM_COMMIT=3132aac04326286ae996bf0887e920096b2bb210
ENV VLLM_VERSION=v1.0.0.dev
ENV DO_NOT_TRACK=1

COPY --chmod=775 endpoints-entrypoint.sh entrypoint.sh
RUN pip install https://vllm-wheels.s3.us-west-2.amazonaws.com/${VLLM_COMMIT}/vllm-${VLLM_VERSION}-cp38-abi3-manylinux1_x86_64.whl

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
CMD [""]
