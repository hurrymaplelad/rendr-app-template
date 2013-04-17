{renderable, a, h3, table, thead, tbody, tr, th, td} = require 'teacup'

module.exports = renderable ({models}) ->
  h3 'Repos'
  table '.repos-table.table', ->
    thead ->
      tr ->
        th 'Name'
        th 'Watchers'
        th 'Forks'
    tbody ->
    for {full_name, name, watchers_count, forks_count} in models
      tr ->
        td -> a href: "/repos/#{full_name}", name
        td watchers_count
        td forks_count
