# state.coffee, a_pinyin/apk/src/redux/

init_state = {
  # color theme
  co: 'dark'  # ['dark', 'light']

  layout: 'qwerty'  # current keyboard layout
    # ['qwerty', 'dvorak', 'abcd1097', 'abcd7109']

  # for pinyin input
  pinyin: {
    raw: ''  # raw user input pinyin str
    cut: []  # core pinyin cut result
    can: []  # core get_text() result
    wait: []  # chinese text wait to commit

    top_more: false
  }

  # for headless bg js task
  headless: {
    count: 0  # +1 every second
  }

  # core status
  core: {
    is_input: false  # true between core_start_input and core_end_input
    input_mode: null  # TODO support input mode ?
    nolog: false  # core nolog mode
  }

  # user model (symbol)
  user: {
    symbol: []
    symbol2: []
  }
}

module.exports = init_state
