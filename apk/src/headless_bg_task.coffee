# headless_bg_task.coffee, a_pinyin/apk/src/

config = require './config'
util = require './util'
action = require './redux/action'


module.exports = (task_data) ->
  # only run one instance
  if config.is_running_headless_bg_task
    return
  # js is single thread, never break here, so this is the lock
  config.is_running_headless_bg_task = true
  # loop forever
  while true  # FIXME change this ?
    # sleep 1s first
    await util.sleep 1e3
    # update count
    config.store?.dispatch action.headless_count()

  # FIXME never got here !
  config.is_running_headless_bg_task = false
  await return
