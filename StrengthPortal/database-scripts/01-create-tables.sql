-- StrengthPortal Database Schema
-- Generated from StrengthPortal.Database project

USE StrengthPortal;
GO

-- Create User table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='User' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[User] (
        [UserID] UNIQUEIDENTIFIER NOT NULL,
        [Email]  NVARCHAR(255) NULL,
        CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([UserID] ASC)
    );
END
GO

-- Insert sample data for development (only if table is empty)
IF NOT EXISTS (SELECT 1 FROM [dbo].[User])
BEGIN
    INSERT INTO [dbo].[User] (UserID, Email) VALUES 
        (NEWID(), 'admin@strengthportal.com'),
        (NEWID(), 'user@strengthportal.com');
END
GO

PRINT 'Database tables created successfully';
