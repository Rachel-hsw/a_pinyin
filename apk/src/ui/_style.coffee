# _style.coffee, a_pinyin/apk/src/ui/

{
  StyleSheet
} = require 'react-native'

style = require '../style'


s = StyleSheet.create {
  # PageTop
  top_back_view: {
    width: style.TOP_HEIGHT
    height: style.TOP_HEIGHT
    flexDirection: 'row'
    alignItems: 'center'
    justifyContent: 'center'
  }
  top_back_text: {
    fontSize: style.TITLE_SIZE
  }
  top_back_text_small: {
    fontSize: style.TEXT_SIZE
  }
  top_placeholder: {
    width: style.TOP_HEIGHT
  }
  top_view: {
    height: style.TOP_HEIGHT
    flexDirection: 'row'
    borderBottomWidth: style.BORDER_WIDTH
  }
  top_back_out_view: {
    height: '100%'
    width: style.TOP_HEIGHT
  }
  top_title_touch: {
    height: '100%'
    flex: 1
    flexDirection: 'row'
  }
  top_title_view: {
    height: '100%'
    flex: 1
    flexDirection: 'row'
    alignItems: 'center'
    justifyContent: 'center'
  }
  top_title_text: {
    flex: 1
    fontSize: style.TITLE_SIZE
    textAlign: 'center'
  }
  # RightItem
  ri_view: {
    height: style.TOP_HEIGHT
  }
  ri_in_view: {
    height: style.TOP_HEIGHT
    width: '100%'
    flexDirection: 'row'
    justifyContent: 'center'
    alignItems: 'center'
  }
  ri_text: {
    paddingLeft: style.TOP_PADDING
    fontSize: style.TITLE_SIZE
  }
  ri_text_sec: {
    flex: 1
    textAlign: 'right'
  }
  ri_right_text: {
    width: style.TOP_HEIGHT
    fontSize: style.TITLE_SIZE
    textAlign: 'center'
  }
  # ScrollPage
  sp_view: {
    flex: 1
    flexDirection: 'column'
  }
  sp_scrollview_container: {
    flexGrow: 1
  }
  sp_view_margin: {
    margin: style.TOP_PADDING
  }

  fill_view: {
    flex: 1
  }

  # SelectableList
  sl_flatlist: {  # Flatlist
    flex: 1
  }
  sl_rm_button: {  # View
    position: 'absolute'
    bottom: 0
    left: 0
    right: 0
    margin: style.TOP_PADDING
  }
  sl_placeholder: {  # Text
    fontSize: style.TEXT_SIZE
    textAlign: 'center'
    paddingTop: style.TOP_PADDING
  }
  # SelectableList.ListItem
  sl_list_item: {  # View
    padding: style.TOP_PADDING
    flexDirection: 'row'
    alignItems: 'center'
    # FIXME border BUG of react-native
    #borderStyle: 'dotted'
    borderBottomWidth: 0.3
  }
  sl_list_item_text: {  # Text
    flex: 1
    fontSize: style.TITLE_SIZE
  }
  sl_list_item_right: {  # Text
    fontSize: style.TITLE_SIZE
  }

  # PageAbout
  about_title_text_1: {
    fontSize: style.TITLE_SIZE
    paddingBottom: style.TOP_PADDING / 2
  }
  about_text: {
    fontSize: style.TEXT_SIZE
    paddingBottom: style.TOP_PADDING / 2
  }
  about_title_text: {
    fontSize: style.TITLE_SIZE
    paddingTop: style.TOP_PADDING / 2
    paddingBottom: style.TOP_PADDING / 2
  }
  about_license_text: {
    fontSize: style.TEXT_SIZE
    padding: style.TOP_PADDING / 2
  }

  # PageDebug
  debug_text: {
    fontSize: style.TEXT_SIZE
  }

  # PageDataUserSymbol2
  dus2_list: {  # View
    flex: 1
  }
  dus2_add: {  # View
    flex: 0
    flexShrink: 0
    padding: style.TOP_PADDING
    paddingTop: style.TOP_PADDING / 2
    paddingBottom: style.TOP_PADDING / 2
    borderBottomWidth: style.BORDER_WIDTH / 2
    flexDirection: 'row'
    alignItems: 'center'
  }
  dus2_text_input: {  # TextInput
    flex: 1
    fontSize: style.TITLE_SIZE
    marginRight: style.TOP_PADDING
  }

  # PageDb
  db_pad_view: {
    marginBottom: style.TOP_PADDING
  }
  db_title_text: {
    fontSize: style.TITLE_SIZE
  }
  db_text: {
    fontSize: style.TEXT_SIZE
  }
  db_dl_button_view: {
    marginTop: style.TOP_PADDING
  }
  db_topad_view: {
    marginTop: style.TOP_PADDING
  }
  db_button: {
    marginTop: style.TOP_PADDING / 2
  }

  # ConfigItem
  config_item_view: {
    flex: 0
    flexShrink: 0
    margin: style.TOP_PADDING / 2
    marginTop: 0
    flexDirection: 'row'
    justifyContent: 'center'
    alignItems: 'center'
    paddingBottom: style.TOP_PADDING / 2
    marginBottom: style.TOP_PADDING / 2
  }
  config_item_left_view: {
    flex: 1
    flexDirection: 'column'
  }
  config_item_right_view: {
    flexDirection: 'column'
    justifyContent: 'center'
    alignItems: 'center'
  }
  config_item_title_text: {
    fontSize: style.TITLE_SIZE
  }
  config_item_text: {
    fontSize: style.TEXT_SIZE
    marginTop: style.TOP_PADDING / 2
  }
  # PageConfig
  config_input: {
    fontSize: style.TITLE_SIZE
    textAlign: 'right'
    width: style.TITLE_SIZE * 3
  }
}

module.exports = s
