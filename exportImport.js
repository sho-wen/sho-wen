const axios = require('axios');
const fetch = require('node-fetch');

const sourceGitlabUrl = 'https://source-gitlab.com/api/v4'; // 源GitLab服务器的URL
const sourceGitlabToken = 'YOUR_SOURCE_GITLAB_TOKEN'; // 源GitLab服务器的访问令牌
const sourceProjectId = 'YOUR_SOURCE_PROJECT_ID'; // 源项目的ID

const destinationGitlabUrl = 'https://destination-gitlab.com/api/v4'; // 目标GitLab服务器的URL
const destinationGitlabToken = 'YOUR_DESTINATION_GITLAB_TOKEN'; // 目标GitLab服务器的访问令牌
const destinationProjectId = 'YOUR_DESTINATION_PROJECT_ID'; // 目标项目的ID

const exportIssues = async () => {
  try {
    // 获取源GitLab服务器上的问题列表
    const sourceIssuesUrl = `${sourceGitlabUrl}/projects/${sourceProjectId}/issues`;
    const sourceIssuesResponse = await axios.get(sourceIssuesUrl, {
      headers: {
        'Private-Token': sourceGitlabToken
      }
    });

    const issues = sourceIssuesResponse.data;

    // 导入问题到目标GitLab服务器
    for (const issue of issues) {
      // 创建问题的URL
      const destinationIssuesUrl = `${destinationGitlabUrl}/projects/${destinationProjectId}/issues`;

      // 从源GitLab服务器获取问题的详细信息
      const sourceIssueUrl = `${sourceGitlabUrl}/projects/${sourceProjectId}/issues/${issue.iid}`;
      const sourceIssueResponse = await axios.get(sourceIssueUrl, {
        headers: {
          'Private-Token': sourceGitlabToken
        }
      });

      // 创建问题到目标GitLab服务器
      await fetch(destinationIssuesUrl, {
        method: 'POST',
        body: JSON.stringify(sourceIssueResponse.data),
        headers: {
          'Content-Type': 'application/json',
          'Private-Token': destinationGitlabToken
        }
      });
    }

    console.log('Issues exported and imported successfully.');
  } catch (error) {
    console.error('An error occurred:', error.response.data);
  }
};

exportIssues();

