{renderable, raw} = require 'teacup'
BaseView = null
modelUtils = null

module.exports =
  view: (viewName, options) ->
    BaseView ||= require('rendr/shared/base/view')
    modelUtils ||= require('rendr/shared/modelUtils')

    viewName = modelUtils.underscorize(viewName)

    options ?= {}

    # get the Backbone.View based on viewName
    ViewClass = BaseView.getView(viewName)
    view = new ViewClass(options)

    # create the outerHTML using className, tagName
    html = view.getHtml()
