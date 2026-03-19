# Oxigraph Setup for Grep

Denne løsningen speiler Apache Jena Fuseki-oppsettet i `..\grep-sparql`, men bruker [Oxigraph](https://github.com/oxigraph/oxigraph) – en rask og effektiv grafdatabase skrevet i Rust.

## Forutsetninger
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installert og kjørende.
- PowerShell (for `ingest.ps1`).

## Slik kommer du i gang

1. **Start Oxigraph-serveren:**
   Åpne en terminal i denne mappen og kjør:
   ```bash
   docker compose up -d
   ```

2. **Last inn data (Wipe-and-Load):**
   Kjør PowerShell-skriptet for å hente data fra Udir og laste det inn i Oxigraph:
   ```powershell
   .\ingest.ps1
   ```
   *Dette skriptet vil tømme det eksisterende `default`-graphet før det laster inn nye data.*

3. **Test spørringer:**
   Oxigraph har et innebygd web-grensesnitt på: [http://localhost:7878](http://localhost:7878)
   Du kan kjøre SPARQL-spørringer der, eller bruke en klient mot `/query`-endepunktet.

## Sammenligning med Fuseki
- **Ytelse:** Oxigraph er ofte raskere og bruker mindre minne enn Fuseki.
- **Wipe:** Vi bruker `CLEAR DEFAULT` via SPARQL Update API-et for en "elegant" wipe.
- **Data:** Skriptet håndterer JSON-LD-formatet direkte, som Oxigraph støtter ut av boksen.
- **Storage:** Data lagres i et Docker-volum (`oxigraph_data`). For å slette alt fysisk, kan du bruke `docker compose down -v`.
