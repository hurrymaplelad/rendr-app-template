exports.getTemplate = (templateName) ->
  require("#{rendr.entryPath}/app/templates/#{templateName}")
