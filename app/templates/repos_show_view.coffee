{renderable, a, br, h3, div, table, tr, th, td} = require 'teacup'

module.exports = renderable (locals) ->
  {
    owner, name, description, language,
    watchers_count, forks_count, open_issues_count
  } = locals

  a href: "/users/#{owner.login}", "#{owner.login} / #{name}"
  br()
  h3 'Stats'
  div '.row-fluid', ->
    div '.span6', ->
      table '.table', ->
        tr ->
          th 'Description'
          td description
        tr ->
          th 'Language'
          td language
        tr ->
          th 'Watchers'
          td watchers_count
        tr ->
          th 'Forks'
          td forks_count
        tr ->
          th 'Open Issues'
          td open_issues_count
