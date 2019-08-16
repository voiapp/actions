# Get tags as output from webhook or repo
Linting golang files with golangci-lint

```
name: build
on: push
jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - uses: voiapp/actions/get-tags@master
      id: tags
    - uses: some/build@v1
      with:
        tags: ${{ steps.tags.outputs.tags  }}
```
