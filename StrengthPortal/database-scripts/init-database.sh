#!/bin/bash

# Wait for SQL Server to be ready
echo "Waiting for SQL Server to start..."
sleep 30

# Create the database
echo "Creating StrengthPortal database..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -Q "CREATE DATABASE StrengthPortal"

# Run the database schema creation
echo "Running database initialization scripts..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -d StrengthPortal -i /docker-entrypoint-initdb.d/01-create-tables.sql

echo "Database initialization completed."
