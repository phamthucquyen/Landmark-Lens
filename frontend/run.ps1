# Load .env file and run Flutter
$envFile = Join-Path $PSScriptRoot ".env"

if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*([^#][^=]+)=(.*)$') {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            if ($key -eq "GOOGLE_PLACES_API_KEY") {
                $apiKey = $value
            }
        }
    }
    
    if ($apiKey) {
        Write-Host "Running Flutter with API key from .env..." -ForegroundColor Green
        $env:GOOGLE_PLACES_API_KEY = $apiKey
        flutter run --dart-define=GOOGLE_PLACES_API_KEY=$apiKey $args
    } else {
        Write-Host "Error: GOOGLE_PLACES_API_KEY not found in .env" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Error: .env file not found" -ForegroundColor Red
    exit 1
}
