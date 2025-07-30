-- Create StrengthPortal Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'StrengthPortal')
BEGIN
    CREATE DATABASE StrengthPortal;
END
GO

USE StrengthPortal;
GO
