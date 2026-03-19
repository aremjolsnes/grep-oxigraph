FROM ghcr.io/oxigraph/oxigraph:latest
EXPOSE 7878
# We use a subfolder /data/oxidb to avoid root-level locking issues on SMB shares.
# Running as default user (oxigraph) is safer if the storage is configured correctly.
ENTRYPOINT ["oxigraph", "serve", "--location", "/data/oxidb", "--bind", "0.0.0.0:7878"]
