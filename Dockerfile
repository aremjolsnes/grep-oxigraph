FROM ghcr.io/oxigraph/oxigraph:latest
USER root
EXPOSE 7878
# Her fjerner vi den feile stien og bare kaller programmet direkte
ENTRYPOINT ["oxigraph", "serve", "--location", "/data", "--bind", "0.0.0.0:7878"]
