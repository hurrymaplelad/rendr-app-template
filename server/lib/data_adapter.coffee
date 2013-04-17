utils = require('./utils')
_ = require('underscore')
url = require('url')
request = require('request')
debug = require('debug')('app:DataAdapter')
inspect = require('util').inspect

module.exports = class DataAdapter

  constructor: (@options = {}) ->

  #
  # `req`: Actual request object from Express/Connect.
  # `api`: Object describing API call; properites including 'path', 'query', etc.
  #        Passed to `url.format()`.
  # `options`: (optional) Options.
  # `callback`: Callback.
  #
  makeRequest: (req, api, options, callback) ->
    if arguments.length is 3
      callback = options
      options = {}

    options = _.clone(options)
    _.defaults options,
      convertErrorCode: true
      allow4xx: false

    api = @apiDefaults api
    start = new Date().getTime()
    request api, (err, response, body) =>
      return callback(err) if err
      end = new Date().getTime()

      debug('%s %s %s %sms', api.method.toUpperCase(), api.url, response.statusCode, end - start)
      debug('%s', inspect(response.headers))

      if options.convertErrorCode
        err = @getErrForResponse(response, {allow4xx: options.allow4xx})
      if typeof body is 'string' && ~(response.headers['content-type'] || '').indexOf('application/json')
        try
          body = JSON.parse(body)
        catch e
          err = e
      callback(err, response, body)

  apiDefaults: (api) ->
    urlOpts = _.defaults(_.pick(api, 'protocol', 'port', 'query'), _.pick(@options, ['protocol', 'port', 'host']))
    urlOpts.pathname = api.path || api.pathname

    api = _.defaults api,
      method: 'GET'
      url: url.format(urlOpts)

    if api.body?
      api.json = api.body

    basicAuth = process.env.BASIC_AUTH
    if basicAuth?
      authParts = basicAuth.split ':'
      api.auth =
        username: authParts[0]
        password: authParts[1]
        sendImmediately: true

    return api

  # Convert 4xx, 5xx responses to be errors.
  getErrForResponse: (res, options) ->
    status = +res.statusCode
    err = null
    if utils.isErrorStatus(status, options)
      err = new Error(status + " status")
      err.status = status
      err.body = res.body
    return err
