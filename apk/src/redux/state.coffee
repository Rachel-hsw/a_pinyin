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

  # database status
  db: {
    ok: null  # is database OK
    dling: false  # doing db download
    cleaning: false  # clean user db
    # core db info
    'core_data.db': {
      path: null
      size: -1
      # from im_native.core_get_db_info
      db_version: null
      db_type: null
      data_version: null
      last_update: null
    }
    'user_data.db': {
      path: null
      size: -1
      # from im_native.core_get_db_info
      db_version: null
      db_type: null
      data_version: null
      last_update: null
    }
  }

  # config values
  config: {
    vibration_ms: 20  # default: 20 ms
    core_level: null
  }
}

module.exports = init_state
