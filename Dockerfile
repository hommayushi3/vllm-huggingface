FROM vllm/vllm-openai:v0.5.5

ENV DO_NOT_TRACK=1

COPY --chmod=775 endpoints-entrypoint.sh entrypoint.sh

RUN pip install -U git+https://github.com/vllm-project/vllm.git@8aaf3d5347ad536de25869caa67b90e43f1ccd5b

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
CMD [""]
