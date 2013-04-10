{renderable, text, h1, p, a} = require 'teacup'

module.exports = renderable ->
  h1 'Wecome to GitHub Browser!'
  p "This is a little app that demonstrates how to use Rendr by consuming GitHub's public Api."
  p ->
    text 'Check out '
    a href: '/repos', 'Repos'
    text ' or '
    a href: '/users', 'Users'
