FROM vllm/vllm-openai:v0.5.5

ENV DO_NOT_TRACK=1

COPY --chmod=775 endpoints-entrypoint.sh entrypoint.sh

RUN pip uninstall -y vllm && pip install git+https://github.com/vllm-project/vllm.git --no-cache-dir

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
CMD [""]
