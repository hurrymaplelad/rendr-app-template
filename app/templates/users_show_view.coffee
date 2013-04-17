{renderable, img, br, div, h3, table, tr, th, td, text} = require 'teacup'
{view} = require '../../rendr-teacup/shared/helpers'

module.exports = renderable (locals) ->
  {
    avatar_url, login, public_repos, 
    repos, location, blog
  } = locals

  img src: avatar_url, width: 80, height: 80
  text """
    #{login} (#{public_repos} public repos)
  """
  br()

  div '.row-fluid', ->
    div '.span6', ->
      view 'user_repos_view', collection: repos

    div '.span6', ->
      h3 'Info'
      br()
      table '.info-table.table', ->
        tr ->
          th 'Location'
          td location
        tr ->
          th 'Blog'
          td blog
