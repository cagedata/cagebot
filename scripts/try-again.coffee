# Description:
#   Tries things again
#
# Dependencies:
#   None
#
# Commands:
#   try again - Try it again
#
# Author:
#   davejlong

module.exports = (robot) ->
  robot.head /try\s?again/i, (msg) ->
    msg.send 'No'

