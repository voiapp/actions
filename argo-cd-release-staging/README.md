# release-staging

Deploys a PR to staging.

This action is meant to be triggered when a review is posted on a Pull Requests.
It expects a `push` target to be available in a Makefile.

## Inputs

### `gcloud-service-account`

**Required** — Base64-encoded service account. Used to download private Docker images.

## Example usage

```yaml
# .github/workflows/argo-cd-release-staging.yml
name: Release to staging
on:
  pull_request_review:
    types: [submitted, edited]

jobs:
  release_staging:
    name: Release to staging
    runs-on: ubuntu-latest

    if: contains(github.event.review.body, 'deploy to staging please')

    steps:
      - uses: actions/checkout@v2

      - uses: voiapp/actions/argo-cd-release-staging@master
        with:
          gcloud-service-account: ${{ secrets.GCLOUD_SERVICE_ACCOUNT }}
          spinnaker-secret: ${{ secrets.SPINNAKER_SECRET }}
```
