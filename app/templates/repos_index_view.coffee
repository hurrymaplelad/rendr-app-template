{renderable, text, h1, ul, li, a} = require 'teacup'

module.exports = renderable ({models}) ->
  h1 'Repos'

  ul ->
    for model in models
      {name, owner:{login}} = model 
      li ->
        a href: "/repos/#{login}/#{name}", name
        text ', by '
        a href: "/users/#{login}", login
