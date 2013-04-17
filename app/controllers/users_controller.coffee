module.exports =
  index: (params, callback) ->
    spec = collection: {collection: 'Users', params}
    @app.fetch spec, (err, result) ->
      callback(err, 'users_index_view', result)

  show: (params, callback) ->
    spec =
      model: {model: 'User', params}
      repos: {collection: 'Repos', params: {user: params.login}}
    @app.fetch spec, (err, result) ->
      callback(err, 'users_show_view', result)

  # This is the same as `show`, but it doesn't fetch the Repos. Instead,
  # the `users_show_lazy_view` template specifies `lazy=true` on its
  # subview. We have both here for demonstration purposes.
  show_lazy: (params, callback) ->
    spec = model: {model: 'User', params}
    @app.fetch spec, (err, result) ->
      return callback(err) if err
      # Extend the hash of options we pass to the view's constructor
      # to include the `template_name` option, which will be used
      # to look up the template file. This is a convenience so we
      # don't have to create a separate view class.
      _.extend(result, template_name: 'users_show_lazy_view')
      callback(err, 'users_show_view', result)
