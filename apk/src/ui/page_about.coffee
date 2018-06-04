# page_about.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text

  ScrollView
} = require 'react-native'

config = require '../config'

{
  PageTop
  ScrollPage

  s
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

  render: ->
    (cE ScrollPage, {
      co: @props.co
      top: (cE PageTop, {
        co: @props.co
        text: '关于'
        on_back: @props.on_back
        })
      margin: true
      },
      # name and page url
      (cE Text, {
        selectable: true
        style: [
          s.about_title_text_1
          @props.co.ui_text
        ] },
        "A拼音: 开源的 Android 拼音输入法"
      )
      (cE Text, {
        selectable: true
        style: [
          s.about_text
          @props.co.ui_text_sec
        ] },
        config.P_VERSION
      )
      (cE Text, {
        selectable: true
        style: [
          s.about_text
          @props.co.ui_text_sec
        ] },
        "https://coding.net/u/sceext2133/p/a_pinyin"
      )
      # license
      (cE Text, {
        style: [
          s.about_title_text
          @props.co.ui_text
        ] },
        "LICENSE"
      )
      (cE View, null,  # FIXME not grow
        (cE ScrollView, {
          horizontal: true
          },
          (cE Text, {
            selectable: true
            style: [
              s.about_license_text
              @props.co.ui_license_text
            ] },
            LICENSE_TEXT
          )
        )
      )
    )
}

module.exports = PageAbout
