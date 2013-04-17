BaseClientRouter = require('rendr/client/router')

module.exports = class Router extends BaseClientRouter

  postInitialize: ->
    @on 'action:start', @trackImpression, @

  trackImpression: ->
    if window._gaq
      _gaq.push ['_trackPageview']
