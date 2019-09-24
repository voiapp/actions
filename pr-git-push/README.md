### GitHub push action

Pushes any changes in pull request made to a GitHub using the GITHUB_TOKEN. Effectively it's doing the following:

> ⚠️ **Warning**: It is working only as a part of the pull request's job
 
```
git diff --quiet || (
  git checkout "$HEAD_BRANCH" && \
    git add . && \
    git commit -m "$1" && \
    git push origin "$HEAD_BRANCH"
)
```

### Usage

```
on:
  pull_request:
    types: [opened]

jobs:
  go-generate:
    runs-on: ubuntu-latest
    steps:
      - name: checkout sources
        uses: actions/checkout@master

      - name: push changes
        uses: ./.github/actions/git-push
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          commit-message: "Commit message"
```

### Arguments

| Key | Description | Default |
|---:|---|---|
| `commit-message` | A commit message to use | default message |
| `commit-user-name` | User name | voi-bender |
| `commit-user-email` | User email | tech@voiapp.io |
