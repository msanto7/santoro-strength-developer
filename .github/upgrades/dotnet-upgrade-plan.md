# .NET 10.0 (Preview) Upgrade Plan

## Execution Steps

Execute steps below sequentially one by one in the order they are listed.

1. Validate that an .NET 10.0 SDK required for this upgrade is installed on the machine and if not, help to get it installed.
2. Ensure that the SDK version specified in global.json files is compatible with the .NET 10.0 upgrade.
3. Upgrade StrengthPortal.Identity\StrengthPortal.Identity.csproj
4. Upgrade StrengthPortal.Api\StrengthPortal.Api.csproj


## Settings

This section contains settings and data used by execution steps.

### Excluded projects

Table below contains projects that do belong to the dependency graph for selected projects and should not be included in the upgrade.

| Project name                                   | Description                 |
|:-----------------------------------------------|:---------------------------:|


### Aggregate NuGet packages modifications across all projects

NuGet packages used across all selected projects or their dependencies that need version update in projects that reference them.

| Package Name                                               | Current Version    | New Version | Description                                   |
|:-----------------------------------------------------------|:-----------------:|:-----------:|:----------------------------------------------|
| Microsoft.AspNetCore.Authentication.JwtBearer              |     9.0.4         |  10.0.0     | Replace with 10.0.0 for .NET 10 compatibility  |
| Microsoft.AspNetCore.Authentication.OpenIdConnect           |     9.0.4         |  10.0.0     | Replace with 10.0.0 for .NET 10 compatibility  |
| Microsoft.AspNetCore.OpenApi                                |   9.0.7;9.0.4     |  10.0.0     | Replace with 10.0.0 for .NET 10 compatibility  |
| Microsoft.VisualStudio.Azure.Containers.Tools.Targets      |    1.21.0         |             | No supported version available for .NET 10 (remove or find alternative)


### Project upgrade details

#### StrengthPortal.Identity modifications

Project properties changes:
  - Target framework should be changed from `net9.0` to `net10.0`

NuGet packages changes:
  - `Microsoft.AspNetCore.OpenApi` should be updated from `9.0.7` to `10.0.0` (recommended for .NET 10)

Other changes:
  - Review any API compatibility warnings after retargeting and update code as required.


#### StrengthPortal.Api modifications

Project properties changes:
  - Target framework should be changed from `net9.0` to `net10.0`

NuGet packages changes:
  - `Microsoft.VisualStudio.Azure.Containers.Tools.Targets` `1.21.0` is incompatible with .NET 10.0. Recommendation: remove or replace with a supported alternative.
  - `Microsoft.AspNetCore.Authentication.JwtBearer` should be updated from `9.0.4` to `10.0.0` (recommended for .NET 10)
  - `Microsoft.AspNetCore.Authentication.OpenIdConnect` should be updated from `9.0.4` to `10.0.0` (recommended for .NET 10)
  - `Microsoft.AspNetCore.OpenApi` should be updated from `9.0.4` to `10.0.0` (recommended for .NET 10)

Other changes:
  - Review any API compatibility warnings after retargeting and update code as required.
