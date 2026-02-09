# Build Flutter Web for Production
# Usage: .\build-web.ps1 -BackendUrl "https://your-backend.onrender.com"

param(
    [Parameter(Mandatory=$true)]
    [string]$BackendUrl
)

Write-Host "Building Flutter Web for production..." -ForegroundColor Green
Write-Host "Backend URL: $BackendUrl" -ForegroundColor Cyan

# Load API key from .env
$envFile = Join-Path $PSScriptRoot ".env"
$apiKey = ""

if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*GOOGLE_PLACES_API_KEY=(.*)$') {
            $apiKey = $matches[1].Trim()
        }
    }
}

if (-not $apiKey) {
    Write-Host "Warning: GOOGLE_PLACES_API_KEY not found in .env" -ForegroundColor Yellow
    Write-Host "Building without API key..." -ForegroundColor Yellow
}

# Build for web
Write-Host "`nBuilding..." -ForegroundColor Yellow

if ($apiKey) {
    flutter build web `
        --dart-define=API_URL=$BackendUrl `
        --dart-define=GOOGLE_PLACES_API_KEY=$apiKey `
        --release
} else {
    flutter build web `
        --dart-define=API_URL=$BackendUrl `
        --release
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✓ Build successful!" -ForegroundColor Green
    
    # Create vercel.json for SPA routing
    $vercelConfig = @"
{
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
"@
    $vercelConfigPath = Join-Path $PSScriptRoot "build\web\vercel.json"
    $vercelConfig | Out-File -FilePath $vercelConfigPath -Encoding utf8
    Write-Host "✓ Created vercel.json" -ForegroundColor Green
    
    Write-Host "`nWeb files location: build/web" -ForegroundColor Cyan
    Write-Host "`nNext steps:" -ForegroundColor Yellow
    Write-Host "  cd build/web" -ForegroundColor White
    Write-Host "  vercel --prod" -ForegroundColor White
} else {
    Write-Host "`n✗ Build failed!" -ForegroundColor Red
    exit 1
}
