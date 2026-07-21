# Wrap stdio portainer-mcp-enhanced in supergateway for streamable HTTP transport
#
# Pinned to our own fork (ghcr.io/jemplayer82) instead of upstream :latest — the
# upstream image had no way to create a standalone (non-edge) stack, and every
# meta-tool's inputSchema only declared "action", so numeric/boolean params
# (id, environmentId, ...) arrived as strings and were rejected. Fixed in
# jemplayer82/portainer-mcp-enhanced (upstream PR
# https://github.com/jmrplens/portainer-mcp-enhanced/pull/11). Pinned to a git
# sha tag, not :latest, so this doesn't silently drift on future fork pushes —
# bump deliberately.
FROM ghcr.io/jemplayer82/portainer-mcp-enhanced:cb8e1b8d1013 AS upstream

FROM ghcr.io/supercorp-ai/supergateway:latest
COPY --from=upstream /usr/local/bin/portainer-mcp-enhanced /usr/local/bin/portainer-mcp-enhanced

# Server URL and token are passed in via env at runtime (see entrypoint).
# Set PORTAINER_SKIP_TLS_VERIFY=true to pass -skip-tls-verify (useful for internal/self-signed certs).
ENV PORTAINER_URL=""
ENV PORTAINER_TOKEN=""
ENV PORTAINER_SKIP_TLS_VERIFY=""
EXPOSE 8000
ENTRYPOINT ["sh", "-c", "TLS_FLAG=\"\"; [ \"$PORTAINER_SKIP_TLS_VERIFY\" = \"true\" ] && TLS_FLAG=\"-skip-tls-verify\"; exec supergateway --outputTransport streamableHttp --port 8000 --stdio \"/usr/local/bin/portainer-mcp-enhanced -server $PORTAINER_URL -token $PORTAINER_TOKEN $TLS_FLAG\""]
