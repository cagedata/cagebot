# Description:
#   Picks a random number in a given range
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_DEFAULT_MIN - unspecified range minimum (default 1)
#   HUBOT_DEFAULT_MAX - unspecified range maximum (default 10)
#
# Commands:
#   hubot pick a number - Picks a random number based on the configuration (Default 1 - 10)
#   hubot pick a number between X and Y - Picks a random number from the range
#   hubot pick a number X to Y - Same as above
#
# Author:
#   crayzeigh

# declare the number to make it not null
number = 42

#Build some varied response for humanization
reply = [
  "Can you use #{number}?",
  "How about... #{number}.",
  "#{number}!",
  "#{number}",
  "Will #{number} work?",
  "no you"
]

module.exports = (robot) ->
  robot.respond /pick a number(( between)? ([0-9]+) (and|to) ([0-9]+))?/i, (msg) ->
    # Do something if no range is specified
    unless msg.match[1]?
      min = process.env.HUBOT_DEFAULT_MIN || 1
      max = process.env.HUBOT_DEFAULT_MAX || 10
      number = Math.floor(Math.random() * max - min) + min
      msg.send msg.random reply

    # Swap min and max if someone types numbers in an less than expected way
    if msg.match[3] > msg.match[5]
      min = msg.match[5]
      max = msg.match[3]
      msg.send "I'll assume you meant #{min} to #{max}..."
    else
      min = msg.match[3]
      max = msg.match[5]
    number = Math.floor(Math.random() * max - min) + min
    msg.send msg.random reply
