# ingest.ps1 - Henter Grep-data og laster det inn i Oxigraph
# Basert på Jena Fuseki-løsningen fra ..\grep-sparql

$oxigraphUrl = "http://localhost:7878"
$storeUrl = "$oxigraphUrl/store?default"
$updateUrl = "$oxigraphUrl/update"
$zipUrl = "https://data.udir.no/kl06/v201906/dump/jsonld"
$tempDir = "./temp_data"
$zipFile = "$tempDir/grep_dump.zip"

# 1. Opprett temp-mappe
if (!(Test-Path $tempDir)) { 
    Write-Host "Oppretter temp-mappe..."
    New-Item -ItemType Directory -Path $tempDir | Out-Null
}

# 2. Last ned data
Write-Host "Laster ned data fra $zipUrl..."
try {
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
} catch {
    Write-Error "Kunne ikke laste ned data: $($_.Exception.Message)"
    exit
}

# 3. Pakk ut
Write-Host "Pakker ut data..."
Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force

# 4. Wipe databasen (CLEAR DEFAULT)
Write-Host "Tømmer databasen (wipe)..."
$clearQuery = "CLEAR DEFAULT"
try {
    Invoke-WebRequest -Uri $updateUrl -Method Post -Body $clearQuery -ContentType "application/sparql-update" -ErrorAction Stop | Out-Null
} catch {
    Write-Error "Kunne ikke tømme databasen. Sjekk at containeren kjører på $oxigraphUrl"
    Write-Error "Feilmelding: $($_.Exception.Message)"
    exit
}

# 5. Last opp til Oxigraph
$files = Get-ChildItem "$tempDir/*.jsonld" -Recurse
Write-Host "Laster opp $($files.Count) filer til Oxigraph ($storeUrl)..."

foreach ($file in $files) {
    Write-Host "Laster opp $($file.Name)..."
    try {
        # Bruker [System.IO.File]::ReadAllBytes for å sikre korrekt håndtering av store filer og encoding
        $content = [System.IO.File]::ReadAllBytes($file.FullName)
        Invoke-WebRequest -Uri $storeUrl -Method Post -Body $content -ContentType "application/ld+json" -ErrorAction Stop | Out-Null
    } catch {
        Write-Warning "Feil ved opplasting av $($file.Name): $($_.Exception.Message)"
    }
}

Write-Host "`nFerdig! Oxigraph er nå oppdatert med Grep-data."
Write-Host "Du kan nå kjøre SPARQL-spørringer mot $oxigraphUrl/query"
Write-Host "Web-grensesnitt (hvis tilgjengelig): $oxigraphUrl"
