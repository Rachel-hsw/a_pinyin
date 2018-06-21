# _kb_style.coffee, a_pinyin/apk/src/keyboard/

{
  StyleSheet
} = require 'react-native'

style = require '../style'


s = StyleSheet.create {
  # TouchableCore (View)
  tc: {
    justifyContent: 'center'
    alignItems: 'center'
  }
  tc_active: {
  }

  # SimpleTouch (Text)
  st: {
    fontSize: style.KB_FONT_SIZE
  }
  st_active: {
  }

  # sec button (View)
  sec: {
    borderWidth: style.BORDER_WIDTH / 2
  }

  # KbLayoutsBoard
  lb: {  # out View
    flex: 1
  }
  lb_in: {  # in View (button / key)
    flex: 0
    position: 'absolute'
  }

  # kb view
  kb_view: {
    marginTop: style.KB_PAD_V
    flex: 1
  }
  # kb_top view
  kb_top: {
    flexShrink: 0
    height: style.KB_TOP_HEIGHT
    borderTopWidth: style.BORDER_WIDTH
    flexDirection: 'row'
  }

  # kb_more
  m_flex: {
    flex: 1
  }
  m_button: {  # View
    borderWidth: style.BORDER_WIDTH / 2
    height: 50
  }
  m_button_text: {  # Text
    fontSize: style.TEXT_SIZE
  }
  m_pad: {  # View
    marginBottom: style.KB_PAD_V
  }
  m_option: {  # View
    flexDirection: 'row'
    marginTop: style.KB_PAD_V
  }
  m_text_nolog: {  # Text
    fontSize: style.TEXT_SIZE
    marginBottom: style.KB_PAD_V
  }
  m_text_title: {  # Title
    fontSize: style.TEXT_SIZE
  }

  # kb_number
  n_view: {  # main kb_number view
    flexDirection: 'row'
  }
  n_button: {  # View
    flex: 1
  }
  n_left: {  # View
    flex: 1
  }
  n_right_part: {  # View
    flex: 0
    flexShrink: 0
    flexDirection: 'row'
    width: style.KB_NUMBER_WIDTH
  }
  n_right: {  # View
    flex: style.KB_NUMBER_RIGHT_BUTTON_FLEX
  }
  n_main: {  # Main
    flex: 3
  }
  n_main_line: {  # View
    flexDirection: 'row'
    flex: 1
  }

  # KbSymbol2
  sy_line: {
    flexDirection: 'row'
    flex: 0
    flexShrink: 0
  }
  # FlatList style
  flatlist: {
    flex: 1
  }

  # KbTop
  top_button: {  # View
    width: style.KB_TOP_WIDTH
  }

  top_text: {  # Text
    fontSize: style.TITLE_SIZE
  }
  top_text_nolog: {  # Text
    fontWeight: 'bold'
  }
  top_space: {  # View
    flex: 1
  }

  # KbTopPinyin
  tp_text: {  # Text
    fontSize: style.TITLE_SIZE
  }
  tp_view: {  # View
    flex: 1
    flexDirection: 'row'
  }
  tp_right: {  # View
    width: style.KB_TOP_WIDTH
  }

  # KbPinyinMore
  pm_view: {
    flex: 1
    flexDirection: 'row'
  }
  pm_left: {  # View
    flex: 1
  }
  pm_line_sep: {  # View
    borderTopWidth: style.KB_BUTTON_BORDER_WIDTH
    marginLeft: style.KB_PINYIN_MORE_LINE_MARGIN
    marginRight: style.KB_PINYIN_MORE_LINE_MARGIN
  }
  pm_line: {  # View
    flex: 1
    flexDirection: 'row'
  }
  pm_right: {  # View
    width: style.KB_PINYIN_MORE_RIGHT_WIDTH
    marginTop: style.KB_PAD_V
  }
  pm_right_button: {  # View
    height: style.KB_SYM_LINE_HEIGHT
  }
  pm_reset_button: {  # Text
    fontSize: style.TEXT_SIZE
  }
}

module.exports = s
