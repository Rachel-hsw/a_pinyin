# util.coffee, a_pinyin/apk/src/

{ ToastAndroid } = require 'react-native'


toast = (text) ->
  ToastAndroid.show text, ToastAndroid.SHORT

sleep = (ms) ->
  new Promise (resolve) ->
    # never reject
    setTimeout resolve, ms

module.exports = {
  toast

  sleep  # async
}
