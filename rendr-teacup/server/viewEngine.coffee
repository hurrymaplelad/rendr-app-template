path = require('path')
_ = require('underscore')
templateFinder = require('../shared/templateFinder')

# TODO: Most of this is copied directly from rendr's handlebars viewEngine
#  - Is using a layout Rendr convention or up the view engine?  
#  - How `bout naming it __layout.*, flexible?
module.exports = (viewPath, data, callback) ->
  data.locals ||= {}

  app = data.app

  layoutData = _.extend {}, data,
    body: getViewHtml(viewPath, data.locals, app)
    appData: app.toJSON()
    bootstrappedData: getBootstrappedData(data.locals, app)
    _app: app

  renderWithLayout(layoutData, callback)


# render with a layout
renderWithLayout = (locals, cb) ->
  getLayoutTemplate (err, templateFn) ->
    return cb(err) if err
    html = templateFn(locals)
    cb(null, html)


getLayoutTemplate = (callback) ->
  callback(null, templateFinder.getTemplate '__layout')


getViewHtml = (viewPath, locals, app) ->
  BaseView = require('rendr/shared/base/view')

  locals = _.clone locals
  # Pass in the app.
  locals.app = app

  name = path.basename(viewPath).replace('.coffee', '')
  View = BaseView.getView(name)
  view = new View(locals)
  view.getHtml()


getBootstrappedData = (locals, app) ->
  modelUtils = require('rendr/shared/modelUtils')

  bootstrappedData = {}
  for own name, modelOrCollection of locals
    if modelUtils.isModel(modelOrCollection) or modelUtils.isCollection(modelOrCollection)
      bootstrappedData[name] =
        summary: app.fetcher.summarize(modelOrCollection)
        data: modelOrCollection.toJSON()

  bootstrappedData
