module.exports = 
  index: (params, callback) ->
    spec = collection: {collection: 'Repos', params}
    @app.fetch spec, (err, result) ->
      callback(err, 'repos_index_view', result)

  show: (params, callback) ->
    spec = model: {
      model: 'Repo'
      params
      ensureKeys: ['language', 'watchers_count']
    }
    @app.fetch spec, (err, result) ->
      callback(err, 'repos_show_view', result)
