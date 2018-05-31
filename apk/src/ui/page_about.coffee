# page_about.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text

  ScrollView
} = require 'react-native'

ss = require '../style'
config = require '../config'

{
  PageTop
} = require './sub'


LICENSE_TEXT = '''\
a_pinyin: Open source Chinese pinyin input method for Android
Copyright (C) 2018  sceext

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
'''

PageAbout = cC {
  displayName: 'PageAbout'

  propTypes: {
    co: PropTypes.object.isRequired

    on_back: PropTypes.func.isRequired
  }

  _about_content: ->
    (cE View, {
      style: {
        flexDirection: 'column'
        margin: ss.TOP_PADDING
      } },
      # name and page url
      (cE Text, {
        selectable: true
        style: {
          fontSize: ss.TITLE_SIZE
          color: @props.co.TEXT
          paddingBottom: ss.TOP_PADDING / 2
        } },
        "A拼音: 开源的 Android 拼音输入法"
      )
      (cE Text, {
        selectable: true
        style: {
          fontSize: ss.TEXT_SIZE
          color: @props.co.TEXT_SEC
          paddingBottom: ss.TOP_PADDING / 2
        } },
        config.P_VERSION
      )
      (cE Text, {
        selectable: true
        style: {
          fontSize: ss.TEXT_SIZE
          color: @props.co.TEXT_SEC
          paddingBottom: ss.TOP_PADDING / 2
        } },
        "https://coding.net/u/sceext2133/p/a_pinyin"
      )
      # license
      (cE Text, {
        style: {
          fontSize: ss.TITLE_SIZE
          color: @props.co.TEXT
          paddingTop: ss.TOP_PADDING / 2
          paddingBottom: ss.TOP_PADDING / 2
        } },
        "LICENSE"
      )
      (cE ScrollView, {
        horizontal: true
        },
        (cE Text, {
          selectable: true
          style: {
            fontSize: ss.TEXT_SIZE
            color: @props.co.TEXT
            backgroundColor: @props.co.BG_SEC
            padding: ss.TOP_PADDING / 2
          } },
          LICENSE_TEXT
        )
      )
    )

  render: ->
    (cE View, {
      style: {
        flex: 1
        flexDirection: 'column'
      } },
      (cE PageTop, {
        co: @props.co
        text: '关于'
        on_back: @props.on_back
        })
      (cE ScrollView, {
        style: {
          flex: 1
          flexDirection: 'column'
        } },
        @_about_content()
      )
    )
}

module.exports = PageAbout
