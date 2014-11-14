# Description:
#   Bring forth zombies
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   (zombie) - Call in a zombie
#
# Author:
#   solap



images = [
  "http://24.media.tumblr.com/tumblr_m35jnyjTco1qikhvso1_100.gif",
  "http://www.netanimations.net/head2.gif",
  "http://www.netanimations.net/Animated-Zombie-Reverse.gif",
  "http://www.freewebs.com/echoeyy/zombie%20getting%20shot.gif"
 ]

module.exports = (robot) ->
  robot.hear /zombi(e|es)/i, (msg) ->
    msg.send msg.random images
