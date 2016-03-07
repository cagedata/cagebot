# Description:
#   Acks VictorOps issues
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_VICTOR_OPS_ID
#   HUBOT_VICTOR_OPS_KEY
# Commands:
#   hubot ack <incident number> <VictorOps user> - Acks issue in VictorOps
#   hubot incidents - Lists all open incidents
#
# Author:
#   Dave Long <dlong@cagedata.com>

module.exports = (robot) ->
  robot.respond /ack\s(\d+)\s(\w+)/i, (msg) ->
    data = {
      userName: msg.match[2],
      incidentNames: [msg.match[1]]
    }
    msg.http("https://api.victorops.com/api-public/v1/incidents/ack")
    .header("X-VO-Api-Id", process.env.HUBOT_VICTOR_OPS_ID)
    .header("X-VO-Api-Key", process.env.HUBOT_VICTOR_OPS_KEY)
    .header("Content-Type", "application/json")
    .patch(JSON.stringify(data)) (err, res, body) ->
      if res.status_code == 200
        msg.reply "Incident #{msg.match[1]} acked"
      else
        console.log(body)
  robot.respond /incidents/i, (msg) ->
    msg.http("https://api.victorops.com/api-public/v1/incidents")
    .header("X-VO-Api-Id", process.env.HUBOT_VICTOR_OPS_ID)
    .header("X-VO-Api-Key", process.env.HUBOT_VICTOR_OPS_KEY)
    .get() (err, res, body) ->
      data = JSON.parse body
      data.incidents.forEach (incident) ->
        msg.send "(#{incident.currentPhase}) #{incident.entityDisplayName}"
