BaseView = require('./base_view')

module.exports = BaseView.extend
  className: 'users_show_view',

  getTemplateData: ->
    data = BaseView.prototype.getTemplateData.call @
    data.repos = @options.repos
    data
module.exports.id = 'UsersShowView'
