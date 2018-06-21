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
s = require './_style'
{
  PageTop
  ScrollPage
} = require './_sub'


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

  _render_sec_text: (text) ->
    (cE Text, {
      selectable: true
      style: [
        s.about_text
        @props.co.ui_text_sec
      ] },
      text
    )

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
      # name
      (cE Text, {
        selectable: true
        style: [
          s.about_title_text_1
          @props.co.ui_text
        ] },
        "A拼音: 开源的 Android 拼音输入法"
      )
      # version
      @_render_sec_text config.P_VERSION
      # URLs for source code
      @_render_sec_text "https://bitbucket.org/sceext2018/a_pinyin/"

      # mirrors
      (cE Text, {
        style: [
          s.about_text
          @props.co.ui_text
        ] },
        '镜像:'
      )
      @_render_sec_text "https://github.com/sceext-mirror-201806/a_pinyin"
      @_render_sec_text "https://gitee.com/sceext2133/a_pinyin"
      @_render_sec_text "https://coding.net/u/sceext2133/p/a_pinyin"

      # LICENSE
      (cE Text, {
        style: [
          s.about_title_text
          @props.co.ui_text
        ] },
        "LICENSE"
      )
      (cE View, null,
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
