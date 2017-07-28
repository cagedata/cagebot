// Description
//   A hubot script to use with schedules to verify that Hubot is up and running
//
// URLs:
//   GET /ping
//   POST /ping
//
// Author:
//   Dave Long <dlong@cagedata.com>

module.exports = function (robot) {
  var pingCallback = function (req, res) {
    res.set('Content-Type', 'text/plain');
    res.send('OK')
  };

  robot.router.get("/ping", pingCallback);
  robot.router.post("/ping", pingCallback);
}
