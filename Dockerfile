# Wrap stdio portainer-mcp-enhanced in supergateway for streamable HTTP transport
FROM ghcr.io/jmrplens/portainer-mcp-enhanced:latest AS upstream

FROM ghcr.io/supercorp-ai/supergateway:latest
COPY --from=upstream /usr/local/bin/portainer-mcp-enhanced /usr/local/bin/portainer-mcp-enhanced

# Server URL and token are passed in via env at runtime (see entrypoint).
# Set PORTAINER_SKIP_TLS_VERIFY=true to pass -skip-tls-verify (useful for internal/self-signed certs).
ENV PORTAINER_URL=""
ENV PORTAINER_TOKEN=""
ENV PORTAINER_SKIP_TLS_VERIFY=""
EXPOSE 8000
ENTRYPOINT ["sh", "-c", "TLS_FLAG=\"\"; [ \"$PORTAINER_SKIP_TLS_VERIFY\" = \"true\" ] && TLS_FLAG=\"-skip-tls-verify\"; exec supergateway --outputTransport streamableHttp --port 8000 --stdio \"/usr/local/bin/portainer-mcp-enhanced -server $PORTAINER_URL -token $PORTAINER_TOKEN $TLS_FLAG\""]
