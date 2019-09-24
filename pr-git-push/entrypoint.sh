#!/bin/sh
set -e

/setup-ci.sh
git config --global user.name "$COMMIT_USER_NAME"
git config --global user.email "$COMMIT_USER_EMAIL"

# shellcheck disable=SC2002
# shellcheck disable=SC2046
DIFF_URL=$(cat "$GITHUB_EVENT_PATH" | jq -r ".pull_request.diff_url")
REPO_FULLNAME=$(cat "$GITHUB_EVENT_PATH" | jq -r ".pull_request.head.repo.full_name")
PR_NUMBER=$(basename "$DIFF_URL" | sed -e "s/.diff//")

echo "PR_NUMBER: $PR_NUMBER"
echo "GITHUB_TOKEN: $GITHUB_TOKEN"
echo "REPO_FULLNAME: $REPO_FULLNAME"

URI=https://api.github.com
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token $GITHUB_TOKEN"

pr_resp=$(curl -X GET -s -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/$REPO_FULLNAME/pulls/$PR_NUMBER")
BASE_BRANCH=$(echo "$pr_resp" | jq -r .base.ref)

# shellcheck disable=SC2039
if [[ -z "$BASE_BRANCH" ]]; then
  echo "Cannot get base branch information for PR #$PR_NUMBER!"
  echo "API response: $pr_resp"
  exit 1
fi

HEAD_BRANCH=$(echo "$pr_resp" | jq -r .head.ref)

echo "HEAD branch of PR: ${HEAD_BRANCH}"
echo "Base branch for PR #$PR_NUMBER is $BASE_BRANCH"

git diff --quiet || (
  git checkout "$HEAD_BRANCH" && \
    git add . && \
    git commit -m "$1" && \
    git push origin "$HEAD_BRANCH"
)
