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

module.exports = (robot) ->
  robot.respond /pick a number(( between)? ((-)?[0-9]+) (and|to) ((-)?[0-9]+))?/i, (msg) ->
    # Check for the existence of a specified range
    if msg.match[1]?
    # get integers from string matches
      min = parseInt(msg.match[3], 10)
      max = parseInt(msg.match[6], 10)
      # Swap numbers if the order is backwards
      if min > max
        [min, max] = [max, min]
        msg.send "I'll assume you meant #{min} to #{max}..."
    else
      # get default values if none are specified
      min = process.env.HUBOT_DEFAULT_MIN || 1
      max = process.env.HUBOT_DEFAULT_MAX || 10
    number = Math.floor(Math.random() * (max - min + 1)) + min
    msg.send(reply(number))

# Creates some humanized replies instead of just raw number output.
reply = (number) ->
  replies[(Math.random() * replies.length) >> 0].replace(/{number}/, number)

replies = [
  "Maybe, {number}?",
  "How about... {number}.",
  "{number}!",
  "{number}",
  "Um... {number}",
  ":grumpycat:"
]
