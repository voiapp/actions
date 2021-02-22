# release-production

Deploys a tag to production.

This action is meant to be triggered when a tag is pushed.
It expects a `push` target to be available in a Makefile.

## Inputs

### `github-pat`

**Required** — Github Personal Access Token. Used to create a PR using GitHub API in another repository.

### `short-sha`

**Required** — Github short SHA

## Example usage

```yaml
# .github/workflows/argo-cd-release-production.yml
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

      - uses: voiapp/actions/argo-cd-release-production@master
        with:
          github-pat: ${{ secrets.REPO_GITHUB_PAT }}
          short-sha: ${{needs.image_create.outputs.short_sha}}
```
