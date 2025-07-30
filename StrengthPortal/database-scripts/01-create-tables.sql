-- StrengthPortal Database Schema
-- Generated from StrengthPortal.Database project

USE StrengthPortal;
GO

-- Create User table
CREATE TABLE [dbo].[User] (
    [UserID] UNIQUEIDENTIFIER NOT NULL,
    [Email]  NVARCHAR(255) NULL,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([UserID] ASC)
);
GO

-- Insert sample data for development
INSERT INTO [dbo].[User] (UserID, Email) VALUES 
    (NEWID(), 'admin@strengthportal.com'),
    (NEWID(), 'user@strengthportal.com');
GO

PRINT 'Database tables created successfully';
