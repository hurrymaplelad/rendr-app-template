_ = require('underscore')

utils = module.exports = {}

utils.isErrorStatus = (statusCode, options = {}) ->
  _.defaults options, allow4xx: false
  statusCode = +statusCode
  if options.allow4xx
    statusCode >= 500 and statusCode < 600
  else
    statusCode >= 400 and statusCode < 600
