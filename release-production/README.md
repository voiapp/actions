# release-production

Deploys a tag to production.

This action is meant to be triggered when a tag is pushed.
It expects a `push` and `trigger_spinnaker` targets to be available in a Makefile.

## Inputs

### `gcloud-service-account`

**Required** — Base64-encoded service account. Used to download private Docker images.

### `spinnaker-secret`

**Required** — Secret used to call the webhook on Spinnaker.

### `swagger-hub-token`

**Optional** — Token used to publish Swagger API documentation to Swagger Hub. Leave empty to disable.

## Example usage

```yaml
# .github/workflows/release-production.yml
name: Release to production
on:
  push:
    tags: ['v*']

jobs:
  release_production:
    name: Release to production
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - uses: voiapp/actions/release-production@master
        with:
          gcloud-service-account: ${{ secrets.GCLOUD_SERVICE_ACCOUNT }}
          spinnaker-secret: ${{ secrets.SPINNAKER_SECRET }}
```
