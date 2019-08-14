# Lint action
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
    - uses: voiapp/actions/lint@master
      with:
        config: .golangci.yaml
        files: './internal,./pkg'
```
