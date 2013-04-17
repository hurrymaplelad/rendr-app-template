# Point to current environment/config values
env = process.env.NODE_ENV || 'development'

exports.get = (env) ->
  require("../../config/#{env}").config

exports.name = env
exports.current = exports.get(env)
