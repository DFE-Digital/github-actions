# Dotnet SonarCloud Scan

A reusable GitHub Action for running SonarCloud analysis on .NET applications by wrapping a build with SonarScanner.

---

## Purpose

This action provides a consistent way to integrate SonarCloud analysis into .NET pipelines without duplicating configuration.

It:

- Configures the .NET SDK
- Ensures the SonarScanner is available
- Runs SonarScanner begin
- Executes the build command
- Runs SonarScanner end

---

## Inputs

- `build-command`: Command used to build the application. Executed between SonarScanner begin and end steps.
- `coverage-report-path`: Path to a Sonar-compatible coverage report (e.g. SonarQube.xml)
- `coverage-exclusions`: Comma-separated list of coverage exclusion patterns
- `dotnet-version`: .NET SDK version used when not using global.json
- `dotnet-tool-restore`: Runs `dotnet tool restore` when true
- `java-distribution`: Java distribution used by SonarScanner (e.g. zulu, temurin, microsoft) (Default: zulu)
- `java-version`: Java version used by SonarScanner
- `sonarcloud-project-key`: SonarCloud project key
- `sonarcloud-organisation`: SonarCloud organisation (Default: dfe-digital)
- `sonarcloud-token`: SonarCloud authentication token
- `sonarcloud-url`: SonarCloud server URL
- `sonarscan-args`: Additional SonarScanner arguments (e.g. /d:sonar.*)
- `use-global-json`: Uses global.json to select the SDK

## Usage

Add the action as a step in your workflow:

```yaml
- name: SonarCloud scan
  uses: DFE-Digital/github-actions/sonarscan-dotnet@main
  with:
    sonarcloud-project-key: your_project_key
    sonarcloud-token: ${{ secrets.SONAR_TOKEN }}
```

---

## Example: with coverage

```yaml
- name: Download merged coverage
  uses: actions/download-artifact@v4
  with:
    name: coverage
    path: coverage-reports

- name: SonarCloud scan
  uses: DFE-Digital/github-actions/sonarscan-dotnet@main
  with:
    sonarcloud-project-key: your_project_key
    sonarcloud-token: ${{ secrets.SONAR_TOKEN }}
    coverage-report-path: coverage-reports/SonarQube.xml
```

---

## Example: using global.json

```yaml
- name: SonarCloud scan
  uses: DFE-Digital/github-actions/sonarscan-dotnet@main
  with:
    sonarcloud-project-key: your_project_key
    sonarcloud-token: ${{ secrets.SONAR_TOKEN }}
    use-global-json: true
```

If `use-global-json` is true, a `global.json` file must exist in the repository.

---

## Example: custom build command

```yaml
with:
  build-command: dotnet build YourSolution.sln --no-restore --no-incremental
```

## Dependabot and SONAR_TOKEN

SonarCloud analysis requires a valid `SONAR_TOKEN` to publish results.

Dependabot pull requests do not have access to repository secrets by default. This means:

- SonarCloud analysis will fail if the action runs on Dependabot PRs without access to `SONAR_TOKEN`
- This is expected behaviour in GitHub and not specific to this action

### Recommended approach

Control execution in the calling workflow to avoid running the scan when secrets are not available:

```yaml
- name: SonarCloud scan
  if: github.actor != 'dependabot[bot]'
  uses: DFE-Digital/github-actions/dotnet-sonarscan@main
  with:
    sonarcloud-project-key: your_project_key
    sonarcloud-token: ${{ secrets.SONAR_TOKEN }}
