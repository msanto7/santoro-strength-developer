# StrengthPortal Database Initialization Script
# This script initializes the database with tables and sample data

Write-Host "Initializing StrengthPortal Database..." -ForegroundColor Green

# Read password from environment or .env file
$envPath = ".\.env"
if (Test-Path $envPath) {
    Get-Content $envPath | ForEach-Object {
        if ($_ -match "^SA_PASSWORD=(.+)$") {
            $env:SA_PASSWORD = $matches[1]
        }
    }
}

if (-not $env:SA_PASSWORD) {
    Write-Error "SA_PASSWORD environment variable not found. Please check your .env file."
    exit 1
}

# Create database
Write-Host "Creating database..." -ForegroundColor Yellow
docker exec strengthportal-sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$env:SA_PASSWORD" -C -i /docker-entrypoint-initdb.d/00-create-database.sql

# Create tables and insert sample data
Write-Host "Creating tables and inserting sample data..." -ForegroundColor Yellow
docker exec strengthportal-sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$env:SA_PASSWORD" -C -i /docker-entrypoint-initdb.d/01-create-tables.sql

# Verify setup
Write-Host "Verifying database setup..." -ForegroundColor Yellow
docker exec strengthportal-sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$env:SA_PASSWORD" -C -d StrengthPortal -Q "SELECT COUNT(*) as UserCount FROM [dbo].[User]"

Write-Host "Database initialization complete!" -ForegroundColor Green
Write-Host "You can now connect to the database using:" -ForegroundColor Cyan
Write-Host "  Server: localhost,1433" -ForegroundColor White
Write-Host "  Database: StrengthPortal" -ForegroundColor White
Write-Host "  Username: sa" -ForegroundColor White
Write-Host "  Password: [from .env file]" -ForegroundColor White
