{doctype, html, head, body, 
 meta, title, link, div, a,
 ul, li, section, coffeescript,
 script, raw, renderable} = require 'teacup'

module.exports = renderable (locals={}) ->
  doctype 5
  html lang: 'en', ->
    head ->
      meta charset: 'utf-8'
      title 'Rendr Example App'
      link href: '/styles.css', media: 'screen', rel: 'stylesheet', type: 'text/css'
      
    body ->
      div '.navbar.navbar-inverse.navbar-fixed-top', ->
        div '.navbar-inner', ->
          div '.container', ->
            a '.brand', href: '/', 'GitHub Browser'
            div '.nav-collapse.collapse', ->
              ul '.nav', ->
                li '.active', -> a href: '/', 'Home'
                li '.active', -> a href: '/repos', 'Repos'
                li '.active', -> a href: '/users', 'Users'
            div '.loading-indicator', -> raw 'Loading&hellip;'

    section '#content.container', ->
      raw locals.body

    script src: '/mergedAssets.js'
    script """
      (function() {
        var App = window.App = new (require('app/app'))(#{JSON.stringify locals.appData});
        App.bootstrapData(#{JSON.stringify locals.bootstrappedData});
        App.start();
      })();
    """