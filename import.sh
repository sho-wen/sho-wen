#!/bin/bash

# 源GitLab服务器的URL和访问令牌
source_gitlab_url="https://source-gitlab.com/api/v4"
source_gitlab_token="YOUR_SOURCE_GITLAB_TOKEN"
source_project_id="YOUR_SOURCE_PROJECT_ID"

# 目标GitLab服务器的URL和访问令牌
destination_gitlab_url="https://destination-gitlab.com/api/v4"
destination_gitlab_token="YOUR_DESTINATION_GITLAB_TOKEN"
destination_project_id="YOUR_DESTINATION_PROJECT_ID"

export_issues() {
  # 获取源GitLab服务器上的问题列表
  source_issues_url="${source_gitlab_url}/projects/${source_project_id}/issues"
  source_issues_response=$(curl --header "Private-Token: ${source_gitlab_token}" ${source_issues_url})

  issues=$(echo "${source_issues_response}" | jq -c '.[]')

  # 导入问题到目标GitLab服务器
  for issue in ${issues}; do
    # 从源GitLab服务器获取问题的详细信息
    issue_iid=$(echo "${issue}" | jq -r '.iid')
    source_issue_url="${source_gitlab_url}/projects/${source_project_id}/issues/${issue_iid}"
    source_issue_response=$(curl --header "Private-Token: ${source_gitlab_token}" ${source_issue_url})

    # 创建问题到目标GitLab服务器
    destination_issues_url="${destination_gitlab_url}/projects/${destination_project_id}/issues"
    curl --header "Content-Type: application/json" --header "Private-Token: ${destination_gitlab_token}" --data "${source_issue_response}" ${destination_issues_url}
  done

  echo "Issues exported and imported successfully."
}

export_issues