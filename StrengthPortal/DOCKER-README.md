# StrengthPortal Docker Setup

This document explains how to run the StrengthPortal application using Docker and Docker Compose.

## Prerequisites

- Docker Desktop for Windows
- Visual Studio Code (optional, for dev container)
- PowerShell (for management scripts)

## ⚠️ **Important: Environment Setup**

**Before starting, you must set up your configuration files:**

1. **Copy environment template:**
   ```powershell
   Copy-Item .env.template .env
   ```

2. **Copy appsettings template:**
   ```powershell
   Copy-Item StrengthPortal.Api\appsettings.Development.json.template StrengthPortal.Api\appsettings.Development.json
   ```

3. **Copy devcontainer template (if using dev containers):**
   ```powershell
   Copy-Item .devcontainer\devcontainer.json.template .devcontainer\devcontainer.json
   ```

4. **Edit all files with your secure passwords:**
   - In `.env`: Change `SA_PASSWORD=YourStrong!Passw0rd_CHANGE_ME`
   - In `appsettings.Development.json`: Change `YOUR_PASSWORD_HERE`
   - In `devcontainer.json`: Change `CHANGE_TO_YOUR_SA_PASSWORD`
   - **Use the same password in all files!**

5. **Never commit these files** - they're already in `.gitignore`

## Quick Start

### Option 1: Using Docker Compose (Recommended for local development)

1. **Start the application:**
   ```powershell
   # Start in detached mode (background)
   .\docker-manager.ps1 -Action up -Detached -Build
   
   # Or start with logs visible
   .\docker-manager.ps1 -Action up -Build
   ```

2. **Access the application:**
   - API: http://localhost:8080
   - SQL Server: localhost:1433 (sa/YourStrong!Passw0rd)

3. **Stop the application:**
   ```powershell
   .\docker-manager.ps1 -Action down
   ```

### Option 2: Using Dev Container (Recommended for development)

1. **Open in Visual Studio Code**
2. **Install the "Dev Containers" extension**
3. **Press `Ctrl+Shift+P` and select "Dev Containers: Reopen in Container"**
4. **Wait for the container to build and start**

The dev container will:
- Set up the complete development environment
- Install all necessary tools (.NET SDK, SQL Server tools, etc.)
- Start SQL Server automatically
- Configure VS Code with recommended extensions
- Set up the database connection

## Docker Commands

### Management Script Commands

```powershell
# Build images
.\docker-manager.ps1 -Action build

# Start services (with build)
.\docker-manager.ps1 -Action up -Build -Detached

# View logs
.\docker-manager.ps1 -Action logs

# Restart services
.\docker-manager.ps1 -Action restart

# Stop services
.\docker-manager.ps1 -Action down

# Clean up everything (removes volumes too)
.\docker-manager.ps1 -Action clean
```

### Manual Docker Compose Commands

```bash
# Start services
docker-compose up -d --build

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild and start
docker-compose up --build

# Clean up (including volumes)
docker-compose down -v --remove-orphans
```

## Database

The SQL Server container will:
- Create the `StrengthPortal` database automatically
- Run initialization scripts from `database-scripts/`
- Persist data in a Docker volume
- Be accessible at `localhost:1433`

### Database Connection Details

- **Server:** localhost:1433 (or sqlserver:1433 from within containers)
- **Database:** StrengthPortal
- **Username:** sa
- **Password:** YourStrong!Passw0rd

## Development Workflow

### With Dev Container (Recommended)

1. Make code changes in VS Code
2. The API will automatically reload with your changes
3. Use the integrated terminal for .NET CLI commands
4. Use the SQL Server extension to query the database

### With Docker Compose

1. Make code changes locally
2. The API container will detect changes and reload automatically
3. Use any SQL client to connect to localhost:1433

## Troubleshooting

### SQL Server Won't Start
- Ensure you have enough memory allocated to Docker (at least 2GB)
- Check if port 1433 is available
- Wait for the health check to pass (can take up to 30 seconds)

### API Won't Connect to Database
- Wait for SQL Server to be fully ready (health check passing)
- Verify the connection string in docker-compose.yml
- Check API logs: `docker-compose logs api`

### Permission Issues
- On Windows, ensure Docker Desktop has proper permissions
- Try running PowerShell as Administrator if needed

### Port Conflicts
- If ports 8080 or 1433 are in use, modify docker-compose.yml to use different ports

## Files Structure

```
StrengthPortal/
├── .devcontainer/              # Dev container configuration
├── database-scripts/           # Database initialization scripts
├── StrengthPortal.Api/        # API project
├── StrengthPortal.Database/   # Database project
├── docker-compose.yml         # Main docker compose file
├── docker-compose.override.yml # Development overrides
├── docker-manager.ps1         # Management script
└── .env                       # Environment variables
```

## Environment Variables

Key environment variables (defined in `.env`):

- `SA_PASSWORD`: SQL Server SA password
- `ASPNETCORE_ENVIRONMENT`: ASP.NET Core environment
- `ConnectionStrings__DefaultConnection`: Database connection string

**🔒 Security Note:** The `.env` file contains sensitive information and should never be committed to Git. Use `.env.template` as a starting point and create your own `.env` file locally.

## Team Setup

**For new team members:**

1. **Clone the repository**
2. **Set up environment:**
   ```powershell
   Copy-Item .env.template .env
   # Edit .env with secure passwords
   ```
3. **Follow the Quick Start guide above**

## Next Steps

1. **Configure your API** to use the database connection string
2. **Add Entity Framework** if not already present
3. **Create database migrations** or update the initialization scripts
4. **Add more services** to docker-compose.yml as needed (Redis, etc.)
5. **Set up CI/CD** pipelines using the Docker setup
