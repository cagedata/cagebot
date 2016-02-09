PlayMusic = require "playmusic"

playlist = "1158bea5-3222-49e2-9c88-11d80bc03388"

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

      pm.addTrackToPlayList song.track.storeId, playlist, (err, mutationStatus) ->
        console.error(err) if err
        msg.send "Okay, I'll play '#{song.track.title}' by '#{song.track.artist}'"
