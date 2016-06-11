# Description:
#   Looks up JIRA issues when they're mentioned in chat.
#   Hubot will ignore users set in HUBOT_JIRA_IGNORE_USERS (by default, JIRA and GitHub)
#
#   Heavily inspired by [rustedgrail/hubot-jira](https://github.com/rudstedgrail/hubot-jira).
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_JIRA_URL (format: "https://jira-domain.com:9090")
#   HUBOT_JIRA_IGNORECASE (optional; default is "true")
#   HUBOT_JIRA_USERNAME (optional)
#   HUBOT_JIRA_PASSWORD (optional)
#   HUBOT_JIRA_IGNORE_USERS (optional, format: "user1|user2", default is "jira|github")
#   HUBOT_JIRA_ISSUE_REGEX (optional, default is )
#
# Author:
#   davejlong

module.exports = (robot) ->
  cache = []

  ignoreUsers = process.env.HUBOT_JIRA_ISSUES_IGNORE_USERS || "jira|github"
  auth = "#{process.env.HUBOT_JIRA_USERNAME}:#{process.env.HUBOT_JIRA_PASSWORD}"

  robot.hear /\b([a-zA-Z]{2,12}-[0-9]{1,10})\b/, (msg) ->
    return if msg.message.user.name.match(new RegExp(ignoreUsers, "gi"))
    issue = msg.match[1]
    robot.http("#{process.env.HUBOT_JIRA_URL}/rest/api/2/issue/#{issue}")
    .auth(auth)
    .get() (err, res, body) ->
      json = JSON.parse(body)
      try
        key = json.key
        url = "#{process.env.HUBOT_JIRA_URL}/browse/#{key}"

        text = []
        text.push "*Type:* #{json.fields.issuetype.name}"
        text.push "*Priority:* #{json.fields.priority.name}"
        text.push "*Status:* #{json.fields.status.name}"
        if json.fields.assignee
          text.push "*Assignee:* #{json.fields.assignee.displayName}"
        else
          text.push "*Assignee:* Unassigned"
        message = {
          channel: "\##{msg.message.room}"
          message: msg.message
          attachments: [
            {
              title: "[<#{url}|#{key}>] #{json.fields.summary}",
              pretext: "",
              text: text.join("\t"),
              mrkdwn_in: [
                "text",
                "pretext"
              ]
            }
          ]
        }
        robot.emit "slack.attachment", message

        if robot.adapterName != "slack"
          message = "[#{key}] #{json.fields.summary}"
          message = "[" + key + "] " + json.fields.summary
          message += '\nStatus: '+json.fields.status.name

          if (json.fields.assignee == null)
            message += ', unassigned'
          else if ('value' of json.fields.assignee or 'displayName' of json.fields.assignee)
            if (json.fields.assignee.name == "assignee" and json.fields.assignee.value.displayName)
              message += ', assigned to ' + json.fields.assignee.value.displayName
            else if (json.fields.assignee and json.fields.assignee.displayName)
              message += ', assigned to ' + json.fields.assignee.displayName
          else
            message += ', unassigned'
          message += ", rep. by "+json.fields.reporter.displayName
          if json.fields.fixVersions and json.fields.fixVersions.length > 0
            message += ', fixVersion: '+json.fields.fixVersions[0].name

          if json.fields.priority and json.fields.priority.name
            message += ', priority: ' + json.fields.priority.name

          msg.send message
      catch error
        msg.send "[*ERROR*] #{error}"
