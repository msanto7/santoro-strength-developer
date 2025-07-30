# Database Management Script for StrengthPortal

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("connect", "reset", "backup", "restore", "export-schema")]
    [string]$Action,
    
    [string]$BackupName = "dev-backup"
)

$ErrorActionPreference = "Stop"

# Check if containers are running
$containers = docker ps --filter "name=strengthportal-sqlserver" --format "{{.Names}}"
if (-not $containers) {
    Write-Host "❌ SQL Server container is not running!" -ForegroundColor Red
    Write-Host "Start it with: .\docker-manager.ps1 -Action up -Detached" -ForegroundColor Yellow
    exit 1
}

Write-Host "Database Management for StrengthPortal" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

switch ($Action) {
    "connect" {
        Write-Host "Connection Information:" -ForegroundColor Yellow
        Write-Host "Server: localhost,1433" -ForegroundColor Cyan
        Write-Host "Database: StrengthPortal" -ForegroundColor Cyan
        Write-Host "Authentication: SQL Server Authentication" -ForegroundColor Cyan
        Write-Host "Login: sa" -ForegroundColor Cyan
        Write-Host "Password: strengthROOT42!" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "📊 Open SSMS and use the above connection details" -ForegroundColor Green
        Write-Host "🔗 Or use VS Code SQL extension with same details" -ForegroundColor Green
    }
    
    "reset" {
        Write-Host "⚠️  Resetting database (all data will be lost)..." -ForegroundColor Yellow
        Read-Host "Press Enter to continue or Ctrl+C to cancel"
        
        # Stop containers, remove volumes, restart
        docker-compose down -v
        docker-compose up -d --build
        Write-Host "✅ Database reset complete!" -ForegroundColor Green
    }
    
    "backup" {
        Write-Host "Creating backup: $BackupName..." -ForegroundColor Yellow
        docker exec strengthportal-sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P strengthROOT42! -Q "BACKUP DATABASE StrengthPortal TO DISK = '/var/opt/mssql/backup/$BackupName.bak'"
        Write-Host "✅ Backup created: $BackupName.bak" -ForegroundColor Green
    }
    
    "restore" {
        Write-Host "Restoring from backup: $BackupName..." -ForegroundColor Yellow
        docker exec strengthportal-sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P strengthROOT42! -Q "RESTORE DATABASE StrengthPortal FROM DISK = '/var/opt/mssql/backup/$BackupName.bak' WITH REPLACE"
        Write-Host "✅ Database restored from: $BackupName.bak" -ForegroundColor Green
    }
    
    "export-schema" {
        Write-Host "Exporting current schema to script..." -ForegroundColor Yellow
        $exportScript = @"
-- Generated schema export $(Get-Date)
USE StrengthPortal;

-- Export table schemas
SELECT 
    'CREATE TABLE [' + TABLE_SCHEMA + '].[' + TABLE_NAME + '] (' +
    STUFF((
        SELECT ', [' + COLUMN_NAME + '] ' + DATA_TYPE + 
               CASE 
                   WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')'
                   WHEN NUMERIC_PRECISION IS NOT NULL THEN '(' + CAST(NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(NUMERIC_SCALE AS VARCHAR) + ')'
                   ELSE ''
               END +
               CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END
        FROM INFORMATION_SCHEMA.COLUMNS c2
        WHERE c2.TABLE_NAME = c1.TABLE_NAME AND c2.TABLE_SCHEMA = c1.TABLE_SCHEMA
        FOR XML PATH('')
    ), 1, 2, '') + ');'
FROM INFORMATION_SCHEMA.COLUMNS c1
GROUP BY TABLE_SCHEMA, TABLE_NAME;
"@
        
        docker exec strengthportal-sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P strengthROOT42! -Q $exportScript
        Write-Host "✅ Schema exported!" -ForegroundColor Green
    }
}

Write-Host "`nDone!" -ForegroundColor Green
