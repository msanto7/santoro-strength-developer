# get current Git branch name
$branch = git rev-parse --abbrev-ref HEAD

$dbName = "strength-portal-$branch"
Write-Host "Deploying to local database: $dbName"

# drop db if exists
Invoke-Sqlcmd -Query "IF DB_ID('$dbName') IS NOT NULL DROP DATABASE [$dbName]" -ServerInstance "RETURNDEV"

# dacpac path
$dacpacPath = ".\StrengthPortal.Database\bin\Debug\StrengthPortal.Database.dacpac"

# SqlPackage.exe path
$sqlPackage = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\SqlPackage.exe"

# deploy using SqlPackage
& "$sqlPackage" /Action:Publish `
    /SourceFile:$dacpacPath `
    /TargetConnectionString:"Server="RETURNDEV";Database=$dbName;Trusted_Connection=True;TrustServerCertificate=True;" `

Write-Host "Deployment complete"

