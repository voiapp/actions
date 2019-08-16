# Firebase Deploy 
Deploys an application to firebase

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
    - uses: voiapp/actions/firebase@master
      with:
        project: gcp-project
        json_sa_key: ${{ secrets.GCP_SECRET }}
```

