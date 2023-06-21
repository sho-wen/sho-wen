#!/bin/bash

# 设置变量
GITHUB_API_ENDPOINT="https://api.github.com"
GITHUB_REPO_OWNER="sho-wen"
GITHUB_REPO_NAME="sho-wen"
GITHUB_TOKEN="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"
OUTPUT_FILE="issues.json"

# 发出API请求获取项目问题，并将结果保存到文件
curl --header "Authorization: Bearer $GITHUB_TOKEN" "$GITHUB_API_ENDPOINT/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/issues" > "$OUTPUT_FILE"

# curl --header "Authorization: Bearer $GITHUB_TOKEN" "$GITHUB_API_ENDPOINT/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/issues" | jq '.[] | {title: .title, body: .body, created_at: .created_at}' > "$OUTPUT_FILE"