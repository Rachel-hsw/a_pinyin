# index.coffee, a_pinyin/apk/src/

{
  createStore
  applyMiddleware
} = require 'redux'
{ default: thunk } = require 'redux-thunk'

{ Provider } = require 'react-redux'

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'


config = require './config'
headless_bg_task = require './headless_bg_task'

reducer = require './redux/reducer'

Main = require './main'
KeyboardView = require './keyboard_view'

# redux store
store = createStore reducer, applyMiddleware(thunk)
# save store to global
config.store = store


O = cC {
  render: ->
    (cE Provider, {
      store
      },
      (cE Main)
    )
}

O2 = cC {
  render: ->
    (cE Provider, {
      store
      },
      (cE KeyboardView)
    )
}


{ AppRegistry } = require 'react-native'

AppRegistry.registerComponent 'a_pinyin_main', () ->
  O
AppRegistry.registerComponent 'keyboard_view', () ->
  O2
# headless bg js task
AppRegistry.registerHeadlessTask 'headless_bg_task', () ->
  headless_bg_task

module.exports = {
  store
  O
  O2
}
