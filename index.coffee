app = module.exports = require('derby').createApp 'todos', __filename
app.serverUse module, 'derby-stylus'
app.loadViews __dirname
app.loadStyles __dirname
app.component require('d-connection-alert')
app.component require('d-before-unload')


## ROUTES ##

app.get '/', (page) ->
  page.redirect '/home'

app.get '/:groupName', (page, model, {groupName}, next) ->
  # Only handle URLs that use alphanumberic characters, underscores, and dashes
  return next() unless /^[a-zA-Z0-9_-]+$/.test groupName

  group = model.at "groups2.#{groupName}"
  group.subscribe (err) ->
    return next err if err

    # Create some todos if this is a new group
    model.ref('_page.todos', group.at 'todos');
    page.render()

app.proto.add = (scoped) ->
  # Don't add a blank todo
  #text = @model.del '_page.newTodo'
  #
  #return unless text
  path = (scoped and scoped.path() + '.replies') or '_page.todos'
  console.log path
  @model.push path, { text: new Date() }