# SonarScanner for .NET - Server
## Overview
**SonarScanner for .NET - Server:**

* Simplifies .NET project analysis using `dotnet-sonarscanner` with SonarQube Server.
* Automatically installs required tools and dependencies (e.g., .NET and `dotnet-sonarscanner`).
* Supports customizable build and test workflows.

If you're using **SonarCloud**, consider using the companion action: [dotnet-sonarscanner-cloud](https://github.com/na1307/dotnet-sonarscanner-cloud).

## Features
* **Automatic Tool Detection and Installation:**
  * Checks for installed .NET and` dotnet-sonarscanner`.
  * Installs the required tools if not already available.
  * Supports specifying a particular version of `dotnet-sonarscanner`.
* **Customizable Build and Test Commands:**
  * Define the shell and commands for building and testing your project.
  * Flexibility to include test coverage and additional properties.

## Inputs
See the [action.yml](action.yml) for details about all available inputs.

### Key Input Notes
* `additional-properties`:
  * Specify extra SonarQube properties.
  * Ensure hyphens (`-`) are used instead of slashes (`/`) to avoid action failures.

## Example Workflows
### 1. Build Only Workflow
This workflow performs a simple build and analysis with SonarQube.
```yml
name: SonarQube

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  sonarqube:
    name: SonarQube
    runs-on: ubuntu-latest
    if: github.event_name == 'push' || github.event.pull_request.head.repo.full_name == github.repository
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: 9.0.x
      - name: SonarScanner for .NET
        uses: na1307/dotnet-sonarscanner-server@v1
        with:
          project-key: myproject
          sonar-token: ${{ secrets.SONAR_TOKEN }}
          sonar-host-url: https://mysonarqube.com
          build-commands: dotnet build
```
----
### 2. Build and Test Workflow with Coverage
This workflow includes testing and coverage collection in addition to the build step.
```yml
name: SonarQube

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  sonarqube:
    name: SonarQube
    runs-on: ubuntu-latest
    if: github.event_name == 'push' || github.event.pull_request.head.repo.full_name == github.repository
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: 9.0.x
      - name: Install dotnet-coverage
        run: dotnet tool install -g dotnet-coverage
      - name: SonarScanner for .NET
        uses: na1307/dotnet-sonarscanner-server@v1
        with:
          project-key: myproject
          sonar-token: ${{ secrets.SONAR_TOKEN }}
          sonar-host-url: https://mysonarqube.com
          additional-properties: -d:sonar.cs.vscoveragexml.reportsPaths=coverage.xml
          build-commands: |
            dotnet restore
            dotnet build --no-restore
            dotnet coverage collect 'dotnet test --no-build --verbosity normal' -f xml  -o 'coverage.xml'
```
----
## Notes
1. Authentication:
    * Use GitHub Secrets to securely store your `SONAR_TOKEN` and other sensitive data.
1. Test Coverage:
    * Ensure you have installed and configured `dotnet-coverage` (or other coverage tools like `coverlet`) if collecting test coverage reports.
1. Additional Customization:
    * Add more commands as needed to meet your project requirements, such as linting or integration tests.

## See also
* [Using the SonarScanner for .NET](https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/scanners/dotnet/using/) (Check out several additional properties)
* [Configuring the SonarScanner for .NET](https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/scanners/dotnet/configuring/)
* [Analysis parameters for SonarScanner](https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/analysis-parameters/) (Even more additional properties)
