# Docker Action
Authenticate, build and push images in one action.

## Usage
```
name: build
on: push
jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - uses: voiapp/actions/docker@master
      with:
        username: username
        password: ${{ secrets.REGISTRY_PASSWORD }}
        registry: 'gcr.io'
        tags: 'latest'
        repo: 'org/repo'
```

