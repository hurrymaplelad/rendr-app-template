utils = require('../lib/utils')
_ = require('underscore')
rendrServer = require('rendr').server

# Middleware handler for intercepting API routes.
module.exports = ->
  (req, res, next) ->
    api = _.pick(req, 'path', 'query', 'method', 'body')
    rendrServer.dataAdapter.makeRequest req, api, {convertErrorCode: false}, (err, response, body) ->
      return next(err) if err
      # Pass through statusCode, but not if it's an i.e. 304.
      status = response.statusCode
      if utils.isErrorStatus(status)
        res.status(status)
      res.json(body)
