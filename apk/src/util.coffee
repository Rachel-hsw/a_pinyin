# util.coffee, a_pinyin/apk/src/

{ ToastAndroid } = require 'react-native'
{ default: MeasureText } = require 'react-native-measure-text'


toast = (text) ->
  ToastAndroid.show text, ToastAndroid.SHORT

sleep = (ms) ->
  new Promise (resolve) ->
    # never reject
    setTimeout resolve, ms


measure_text_width = (texts, fontSize, height) ->
  await MeasureText.widths {
    texts
    fontSize
    height
    # FIXME BUG of react-native-measure-text here
    fontFamily: null
    fontWeight: ''
  }

module.exports = {
  toast

  sleep  # async

  measure_text_width  # async
}
