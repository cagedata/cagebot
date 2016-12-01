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


module.exports = (robot) ->

  robot.respond /pick a number(( between)? ((-)?[0-9]+) (and|to) ((-)?[0-9]+))?/i, (msg) ->
    # Do something if no range is specified
#    unless msg.match[1]?
#      min = process.env.HUBOT_DEFAULT_MIN || 1
#      max = process.env.HUBOT_DEFAULT_MAX || 10
#      number = Math.floor(Math.random() * max - min + 1) + min
#      msg.send(reply(number))

    # Check for the existence of a specified range
    if msg.match[1]?
    # get integers from strings
      min = parseInt(msg.match[3], 10)
      max = parseInt(msg.match[6], 10)
      if min > max
        [min, max] = [max, min]
        msg.send "I'll assume you meant #{min} to #{max}..."
    else
      min = process.env.HUBOT_DEFAULT_MIN || 1
      max = process.env.HUBOT_DEFAULT_MAX || 10
    number = Math.floor(Math.random() * (max - min + 1)) + min
    msg.send(reply(number))

reply = (number) ->
  replies[(Math.random() * replies.length) >> 0].replace(/{number}/, number)

replies = [
  "Can you use {number}?",
  "How about... {number}.",
  "{number}!",
  "{number}",
  "Will {number} work?",
  "no you"
]
