# Oxigraph Setup for Grep

Denne løsningen speiler Apache Jena Fuseki-oppsettet i `..\grep-sparql`, men bruker [Oxigraph](https://github.com/oxigraph/oxigraph) – en rask og effektiv grafdatabase skrevet i Rust.

## Forutsetninger
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installert og kjørende.
- En [Azure Free Account](https://azure.microsoft.com/free) (valgfritt for sky-test).

## Lokal kjøring

1.  **Start Oxigraph-serveren:**
    ```bash
    docker compose up -d
    ```
2.  **Last inn data (Wipe-and-Load):**
    ```powershell
    .\ingest.ps1
    ```
3.  **Test:** Gå til [http://localhost:7878](http://localhost:7878).

## Distribuert i Azure (Container Apps)

Dette prosjektet er ferdig oppsatt for å kjøre i en **Azure Container App** med "Scale to Zero" (sover når den ikke er i bruk for å spare penger).

### GitHub Actions:
- `deploy-azure.yml`: Bygger og ruller ut koden til Azure (via GitHub Registry).
- `ingest-data.yml`: Henter nattlige oppdateringer fra Udir og laster dem opp til skyen.

### Nødvendige Secrets i GitHub:
- `AZURE_CREDENTIALS`: Azure Service Principal (JSON).
- `OXIGRAPH_URL`: URL til din Container App i Azure.
- `OXIGRAPH_USER` / `OXIGRAPH_PASSWORD`: Hvis du har satt opp sikring av tjenesten.
