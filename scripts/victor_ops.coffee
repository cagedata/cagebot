# Description:
#   Acks VictorOps issues
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_VICTOR_OPS_ID
#   HUBOT_VICTOR_OPS_KEY
#   HUBOT_VICTOR_OPS_MAP
# Commands:
#   hubot ack <incident number> <VictorOps user> - Acks issue in VictorOps
#   hubot incidents - Lists all open incidents
#
# Author:
#   Dave Long <dlong@cagedata.com>

module.exports = (robot) ->
  userMap = JSON.parse process.env.HUBOT_VICTOR_OPS_MAP

  robot.respond /ack\s(\d+)\b/i, (msg) ->
    data = {
      userName: userMap[msg.message.user.email_address],
      incidentNames: [msg.match[1]]
    }
    msg.http("https://api.victorops.com/api-public/v1/incidents/ack")
    .header("X-VO-Api-Id", process.env.HUBOT_VICTOR_OPS_ID)
    .header("X-VO-Api-Key", process.env.HUBOT_VICTOR_OPS_KEY)
    .header("Content-Type", "application/json")
    .patch(JSON.stringify(data)) (err, res, body) ->
      body = JSON.parse body
      if res.status_code == 200
        msg.reply "Incident #{msg.match[1]} acked"
      else
        body.results.forEach (incident) ->
          console.log(incident)
          msg.reply "Incident #{incident.incidentNumber}: #{incident.message}"
  robot.respond /incidents/i, (msg) ->
    msg.http("https://api.victorops.com/api-public/v1/incidents")
    .header("X-VO-Api-Id", process.env.HUBOT_VICTOR_OPS_ID)
    .header("X-VO-Api-Key", process.env.HUBOT_VICTOR_OPS_KEY)
    .get() (err, res, body) ->
      data = JSON.parse body
      data.incidents.forEach (incident) ->
        msg.send "(#{incident.currentPhase}) #{incident.entityId}"
