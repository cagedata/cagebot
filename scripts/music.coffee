PlayMusic = require "playmusic"
pm = new PlayMusic()
pm.init {email: process.env.HUBOT_GOOGLE_MUSIC_USERNAME, password: process.env.HUBOT_GOOGLE_MUSIC_PASSWORD}, (err) ->
  console.error(err) if err

module.exports = (robot) ->
  robot.respond /(play|spin\ me) (.+)/i, (msg) ->
    pm.search msg.match[2], 5, (err, data) ->
      console.error(err) if err
      if err
        return msg.send err

      songs = data.entries.filter (song) ->
        song.type == "1"
      # console.log(data)
      song = songs.sort((a, b) -> a.score < b.score).shift()
      msg.send "Okay, I'll play '#{song.track.title}' by '#{song.track.artist}'"
      pm.getStreamUrl(song.track.storeId, msg.send)

