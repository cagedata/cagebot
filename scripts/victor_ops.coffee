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
#   hubot ack <num> - Acks issue in VictorOps
#   hubot incidents - Lists all open incidents
#
# Author:
#   Dave Long <dlong@cagedata.com>

module.exports = (robot) ->
  robot.respond /ack\s(\d+)/i, (msg) ->
    console.log(msg.match[1])

  robot.respond /incidents/i, (msg) ->
    msg.http("https://api.victorops.com/api-public/v1/incidents")
    .header("X-VO-Api-Id", process.env.HUBOT_VICTOR_OPS_ID)
    .header("X-VO-Api-Key", process.env.HUBOT_VICTOR_OPS_KEY)
    .get() (err, res, body) ->
      data = JSON.parse body
      data.incidents.forEach (incident) ->
        msg.send "(#{incident.currentPhase}) #{incident.entityDisplayName}"
