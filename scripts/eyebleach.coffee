# Description:
#   Hubot delivers some refreshing eye bleach from Reddit's r/aww
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot eyebleach - Display a picture from /r/aww
#   hubot eyebleach n - Display n pictures from /r/aww
#
# Author:
#   eliperkins

url = require("url")

module.exports = (robot) ->
  robot.respond /eyebleach( (\d))?/i, (msg) ->
    count = msg.match[2] || 1
    search = escape(msg.match[1])
    msg.http('http://www.reddit.com/r/aww.json')
      .get() (err, res, body) ->
        result = JSON.parse(body)

        urls = [ ]
        for child in result.data.children
          if child.data.domain != "self.aww"
            urls.push(child.data.url)

        if urls.count <= 0
          msg.send "Couldn't find anything cute..."
          return

        rnd = Math.floor(Math.random()*urls.length)
        picked_url = urls[rnd]

        parsed_url = url.parse(picked_url)
        if parsed_url.host == "imgur.com"
          parsed_url.host = "i.imgur.com"
          parsed_url.pathname = parsed_url.pathname + ".jpg"

          picked_url = url.format(parsed_url)

        msg.send picked_url
