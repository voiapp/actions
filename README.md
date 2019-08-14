# Actions
Actions that we use at VOI to work with GitHub actions.

## What actions do we have here?
### Docker Tools
A set of actions to work with docker.

#### Docker
Authenticate, build and push images with Docker.
##### Usage
```yaml
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
#### Kaniko
Authenticate, build and push images with Kaniko.
##### Usage
Same as above, there is also the possibility to add a google service account to use.
```yaml
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
        json_key: ${{ secrets.SERVICE_ACCOUNT_JSON_KEY }}
        registry: 'gcr.io'
        tags: 'latest'
        repo: 'org/repo'
```
