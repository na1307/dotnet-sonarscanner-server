# SonarScanner for .NET - Server
Makes it easy to use SonarScanner for .NET with SonarQube Server.

Are you using SonarQube Cloud? Check out [dotnet-sonarscanner-cloud](https://github.com/na1307/dotnet-sonarscanner-cloud)!

# Features
* Analyze your project/solution using the .NET Core version of SonarScanner for .NET (`dotnet-sonarscanner`)
* Check if .NET installed and install it if not installed.
* Check if `dotnet-sonarscanner` installed and install it if not installed.
* Install a specific version of `dotnet-sonarscanner`
* Customize build commands

# Inputs
See [action.yml](action.yml).

> Note: You must use hyphens (-) and not slashes (/) in the `additional-properties` input. Otherwise the action may fail.

# Example Workflows
Build only:
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

Build and Test:
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
