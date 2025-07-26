# StrengthPortal Docker Management Script

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("build", "up", "down", "logs", "restart", "clean")]
    [string]$Action,
    
    [switch]$Detached,
    [switch]$Build
)

$ErrorActionPreference = "Stop"

# Check if .env file exists
if (-not (Test-Path ".env")) {
    Write-Host "❌ Missing .env file!" -ForegroundColor Red
    Write-Host "Please copy .env.template to .env and configure your passwords:" -ForegroundColor Yellow
    Write-Host "   Copy-Item .env.template .env" -ForegroundColor Cyan
    Write-Host "Then edit .env with secure passwords before running Docker commands." -ForegroundColor Yellow
    exit 1
}

Write-Host "StrengthPortal Docker Management" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green

switch ($Action) {
    "build" {
        Write-Host "Building Docker images..." -ForegroundColor Yellow
        docker-compose build
    }
    
    "up" {
        Write-Host "Starting services..." -ForegroundColor Yellow
        $cmd = "docker-compose up"
        if ($Build) { $cmd += " --build" }
        if ($Detached) { $cmd += " -d" }
        Invoke-Expression $cmd
        
        if ($Detached) {
            Write-Host "`nServices started in detached mode!" -ForegroundColor Green
            Write-Host "API: http://localhost:8080" -ForegroundColor Cyan
            Write-Host "SQL Server: localhost:1433" -ForegroundColor Cyan
            Write-Host "`nUse 'docker-compose logs -f' to view logs" -ForegroundColor Gray
        }
    }
    
    "down" {
        Write-Host "Stopping services..." -ForegroundColor Yellow
        docker-compose down
        Write-Host "Services stopped!" -ForegroundColor Green
    }
    
    "logs" {
        Write-Host "Showing logs..." -ForegroundColor Yellow
        docker-compose logs -f
    }
    
    "restart" {
        Write-Host "Restarting services..." -ForegroundColor Yellow
        docker-compose restart
        Write-Host "Services restarted!" -ForegroundColor Green
    }
    
    "clean" {
        Write-Host "Cleaning up Docker resources..." -ForegroundColor Yellow
        docker-compose down -v --remove-orphans
        docker system prune -f
        Write-Host "Cleanup completed!" -ForegroundColor Green
    }
}

Write-Host "`nDone!" -ForegroundColor Green
