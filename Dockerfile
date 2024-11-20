FROM vllm/vllm-openai:v0.6.4.post1


ENV VLLM_VERSION=v0.6.4.post1
ENV DO_NOT_TRACK=1

COPY --chmod=775 endpoints-entrypoint.sh entrypoint.sh

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
CMD [""]
