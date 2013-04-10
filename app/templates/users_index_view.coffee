{renderable, h1, ul, li, a} = require 'teacup'

module.exports = renderable ({models}) ->
  h1 'Users'

  ul ->
    for {login} in models
      li ->
        a href: "/users/#{login}", login
