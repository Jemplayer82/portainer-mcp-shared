# Wrap stdio portainer-mcp-enhanced in supergateway for streamable HTTP transport
FROM ghcr.io/jmrplens/portainer-mcp-enhanced:latest AS upstream

FROM ghcr.io/supercorp-ai/supergateway:latest
COPY --from=upstream /usr/local/bin/portainer-mcp-enhanced /usr/local/bin/portainer-mcp-enhanced

# Server URL and token are passed in via env at runtime (see entrypoint).
ENV PORTAINER_URL=""
ENV PORTAINER_TOKEN=""
EXPOSE 8000
ENTRYPOINT ["sh", "-c", "exec supergateway --outputTransport streamableHttp --port 8000 --stdio \"/usr/local/bin/portainer-mcp-enhanced -server $PORTAINER_URL -token $PORTAINER_TOKEN\""]
