templateFinder = require('../../rendr-teacup/shared/templateFinder')
RendrView = require('rendr/shared/base/view')

# Create a base view, for adding common extensions to our
# application's views.

module.exports = RendrView.extend {
  getTemplate: ->
    templateFinder.getTemplate(@getTemplateName())
}
