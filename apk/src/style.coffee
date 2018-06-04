# style.coffee, a_pinyin/apk/src/

{
  StyleSheet
} = require 'react-native'

# size
LEFT_WIDTH = 150
LEFT_ICON_SIZE = 20
TOP_HEIGHT = 50
TOP_ICON_SIZE = 30
TOP_PADDING = 10

TEXT_SIZE = 15
TITLE_SIZE = 20

LOG_TEXT_SIZE = 10

# border
BORDER_WIDTH = 1


# keyboard
KB_HEIGHT = 250
KB_TOP_HEIGHT = 40
KB_TOP_WIDTH = 45
KB_BODY_HEIGHT = KB_HEIGHT - KB_TOP_HEIGHT
KB_PAD_V = 5  # keyboard vertical padding
KB_PAD_H = 2  # keyboard horizontal padding

KB_C_WIDTH = 29  # small char width
KB_BUTTON_WIDTH = 70  # main right buttons width
KB_BUTTON_WIDTH2 = 60  # second button width
KB_BORDER_RADIUS = 5  # for keyboard buttons
KB_FONT_SIZE = 25

KB_BUTTON_BORDER_WIDTH = 0.5
KB_NUMBER_WIDTH = 300
KB_NUMBER_RIGHT_BUTTON_FLEX = 0.8
KB_SYM_LINE_HEIGHT = (KB_BODY_HEIGHT - KB_PAD_V) / 4  # for symbol input, 4 lines per screen

KB_PINYIN_MORE_RIGHT_WIDTH = 50
KB_PINYIN_MORE_LINE_MARGIN = 10

KB_SPACE_BUTTON_FONT_SIZE = 10


# global styles
ss = StyleSheet.create {
  kb_view: {
    marginTop: KB_PAD_V
    flex: 1
  }
  kb_sym_line_view: {
    flexDirection: 'row'
    height: KB_SYM_LINE_HEIGHT
  }
  kb_scrollview: {
    flex: 1
  }

  kb_top_view: {
    flexShrink: 0
    height: KB_TOP_HEIGHT
    borderTopWidth: BORDER_WIDTH
    flexDirection: 'row'
  }

  keyboard_view: {
    height: KB_HEIGHT
  }
  ui_main_view: {
    flex: 1
    flexDirection: 'column'
  }

  # TODO
}

module.exports = {
  LEFT_WIDTH
  LEFT_ICON_SIZE
  TOP_HEIGHT
  TOP_ICON_SIZE
  TOP_PADDING

  TEXT_SIZE
  TITLE_SIZE
  LOG_TEXT_SIZE

  BORDER_WIDTH

  KB_HEIGHT
  KB_TOP_HEIGHT
  KB_TOP_WIDTH
  KB_BODY_HEIGHT
  KB_PAD_V
  KB_PAD_H

  KB_C_WIDTH
  KB_BUTTON_WIDTH
  KB_BUTTON_WIDTH2
  KB_BORDER_RADIUS
  KB_FONT_SIZE

  KB_BUTTON_BORDER_WIDTH
  KB_NUMBER_WIDTH
  KB_NUMBER_RIGHT_BUTTON_FLEX
  KB_SYM_LINE_HEIGHT
  KB_PINYIN_MORE_RIGHT_WIDTH
  KB_PINYIN_MORE_LINE_MARGIN

  KB_SPACE_BUTTON_FONT_SIZE

  ss
}
