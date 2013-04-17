# jshint strict:false

server = require('./server/server')

port = process.env.PORT or 3030

server.init {}, (err) ->
  throw err if err
  server.start {port}
