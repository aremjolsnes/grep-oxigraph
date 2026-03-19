FROM ghcr.io/oxigraph/oxigraph:latest
EXPOSE 7878
ENTRYPOINT ["/usr/bin/oxigraph", "serve", "--location", "/data", "--bind", "0.0.0.0:7878"]
