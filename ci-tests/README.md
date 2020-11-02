# ci-lint

Runs a standard test suite.

This action is meant to be used in Pull Requests and expects a `test` target to be available in a Makefile.

## Inputs

### `gcloud-service-account`

**Required** — Base64-encoded service account. Used to download private Docker images.

## Example usage

```yaml
# .github/workflows/ci.yml
name: CI
on: [pull_request]

jobs:
  lint:
    name: Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - uses: voiapp/actions/ci-tests@master
        with:
          gcloud-service-account: ${{ secrets.GCLOUD_SERVICE_ACCOUNT }}
```
