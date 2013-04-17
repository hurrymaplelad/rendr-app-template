#
# Home of the main server object
#
require('coffee-script')
express = require('express')
env = require('./lib/env')
mw = require('./middleware')
DataAdapter = require('./lib/data_adapter')
rendrServer = require('rendr').server
rendrMw = require('rendr/server/middleware')
viewEngine = require('../rendr-teacup/server/viewEngine')

app = express()

#
# Initialize our server
#
exports.init = (options, callback) ->
  initMiddleware()
  initLibs (err, result) ->
    return callback(err) if err
    buildRoutes(app)
    callback(null, result)

#
# options
# - port
#
exports.start = (options = {}) ->
  port = options.port || 3030
  app.listen(port)
  console.log("server pid " + process.pid + " listening on port " + port + " in " + app.settings.env + " mode")

#
# Initialize middleware stack
#
initMiddleware = ->
  app.configure ->
    # set up views
    app.set('views', __dirname + '/../app/views')
    app.set('view engine', 'coffee')
    app.engine('coffee', viewEngine)

    # set the middleware stack
    app.use(express.compress())
    app.use(express.static(__dirname + '/../public'))
    app.use(express.logger())
    app.use(express.bodyParser())
    app.use(app.router)
    app.use(mw.errorHandler())

#
# Initialize our libraries
#
initLibs = (callback) ->
  options =
    dataAdapter: new DataAdapter(env.current.api)
    errorHandler: mw.errorHandler()
  rendrServer.init(options, callback)

#
# Routes & middleware
#

# Attach our routes to our server
buildRoutes = (app) ->
  buildApiRoutes(app)
  buildRendrRoutes(app)
  app.get(/^(?!\/api\/)/, mw.handle404())

# Insert these methods before Rendr method chain for all routes, plus API.
preRendrMiddleware = [
  # Initialize Rendr app, and pass in any config as app attributes.
  rendrMw.initApp(env.current.rendrApp)
]

buildApiRoutes = (app) ->
  fnChain = preRendrMiddleware.concat(mw.apiProxy())
  fnChain.forEach (fn) ->
    app.use('/api', fn)

buildRendrRoutes = (app) ->
  # attach Rendr routes to our Express app.
  routes = rendrServer.router.buildRoutes()
  routes.forEach (args) ->
    path = args.shift()
    definition = args.shift()

    # Additional arguments are more handlers.
    fnChain = preRendrMiddleware.concat(args)

    # Have to add error handler AFTER all other handlers.
    fnChain.push(mw.errorHandler())

    # Attach the route to the Express server.
    app.get(path, fnChain)
