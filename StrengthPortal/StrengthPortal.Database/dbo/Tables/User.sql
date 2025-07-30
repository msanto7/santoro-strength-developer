CREATE TABLE [dbo].[User] (
    [UserID] UNIQUEIDENTIFIER NOT NULL,
    [Email]  NCHAR (10)       NULL,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([UserID] ASC)
);

