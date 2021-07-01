#run-testproject

An action for triggering a TestProject run in a virtual environment.

## Inputs

### `project-id`

**Required** - String. The id of the project to trigger.

### `job-id`

**Required** - String. The id of the job to trigger.

### `agent-id`

**Requried** - String. The id of the agent to run the job in. Needs to be a virtual agent.

### `api-key`

**Required** - String. Your TestProject api key. Needs to be configured to have access to the project you want to trigger.

## Example usage

```yaml
# .github/workflows/ci-test-project.yml
name: CI - Run TestProject
on: [pull_request]

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - name: Run Test Project
        uses: voiapp/actions/run-testproject
        with:
          project-id: ${{ secrets.TESTPROJECT_PROJECT_ID }}
          job-id: ${{ secrets.TESTPROJECT_JOB_ID }}
          agent-id: ${{ secrets.TESTPROJECT_AGENT_ID }}
          api-key: ${{ secrets.TESTPROJECT_API_KEY }}
```
