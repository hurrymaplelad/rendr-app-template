BaseApp = require('rendr/shared/app')
BaseView = require('rendr/shared/base/view')
templateFinder = require('../rendr-teacup/shared/templateFinder')

module.exports = BaseApp.extend
  defaults:
    loading: false
    templateFinder: templateFinder

  postInitialize: ->
    BaseView::getTemplate = ->
      templateFinder.getTemplate @getTemplateName()

  # @client
  start: ->
    # Show a loading indicator when the app is fetching.
    @router.on 'action:start', => @set loading: true
    @router.on 'action:end', => @set loading: false

    # Call 'super'.
    BaseApp::start.call @
