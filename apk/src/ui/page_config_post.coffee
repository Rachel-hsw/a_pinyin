# page_config_post.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text
} = require 'react-native'

s = require './_style'
{
  PageTop
  ScrollPage
} = require './_sub'


PageConfigPost = cC {
  displayName: 'PageConfigPost'

  propTypes: {
    co: PropTypes.object.isRequired

    on_back: PropTypes.func.isRequired
  }

  render: ->
    (cE ScrollPage, {
      co: @props.co
      top: (cE PageTop, {
        co: @props.co
        text: 'POST 接口'
        on_back: @props.on_back
        })
      margin: true
      },
      # TODO
    )
}

module.exports = PageConfigPost
