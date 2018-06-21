package org.sceext.a_pinyin

import android.content.Intent
import android.inputmethodservice.InputMethodService
import android.view.View
import android.view.inputmethod.EditorInfo
import android.view.KeyEvent

import org.sceext.a_pinyin.core.CoreInput


var pinyin_service: PinyinService? = null

class PinyinService : InputMethodService() {

    private var _keyboard_view: KeyboardView? = null
    private var _show_pinyin = ShowPinyin()
    private var _core = CoreInput()

    override fun onCreate() {
        super.onCreate()
        // start BgJsService here
        val i = Intent(getApplicationContext(), BgJsService::class.java)
        getApplicationContext().startService(i)
        // FIXME TODO stop BgJsService ?

        pinyin_service = this

        _core.init()
    }
    // TODO: add more lifecycle callbacks
    // TODO: improve lifecycle callback passthrough to pinyin core

    override fun onCreateInputView(): View {
        _keyboard_view = KeyboardView(this)

        return _keyboard_view!!.getView()
    }

    override fun onCreateCandidatesView(): View {
        return _show_pinyin.get_view(this)
    }

    override fun onBindInput() {
        super.onBindInput()
    }

    override fun onUnbindInput() {
        super.onUnbindInput()
    }

    override fun onStartInputView(info: EditorInfo, restarting: Boolean) {
        _keyboard_view!!.onShow()

        // TODO support input mode
        _core.on_start_input()
    }

    override fun onFinishInput() {
        _keyboard_view?.onHide()

        _core.on_end_input()
    }

    override fun onDestroy() {
        super.onDestroy()

        _keyboard_view?.onDestroy()

        _core.on_destroy()

        pinyin_service = null
    }

    fun close_window() {
        _core.on_end_input()

        // run on UI thread
        run_on_ui_thread(object: Runnable {
            override fun run() {
                hideWindow()
            }
        })
    }

    fun add_text(text: String, mode: Int, pin_yin: String?) {
        // for core to log user input
        _core.on_input(text, mode, pin_yin)

        currentInputConnection.commitText(text, 1)
    }

    private fun _send_one_key(keycode: Int) {
        val c = currentInputConnection
        val event = KeyEvent.changeFlags(
            KeyEvent(KeyEvent.ACTION_DOWN, keycode),
            KeyEvent.FLAG_SOFT_KEYBOARD)
        c.sendKeyEvent(event)

        val event2 = KeyEvent.changeAction(event, KeyEvent.ACTION_UP)
        c.sendKeyEvent(event2)
    }

    fun key_delete() {
        // TODO support long-press delete key?
        _send_one_key(KeyEvent.KEYCODE_DEL)  // backspace key
    }

    fun key_enter() {
        _core.on_input()  // null input

        _send_one_key(KeyEvent.KEYCODE_ENTER)
    }

    private fun _show_pinyin(show: Boolean) {
        run_on_ui_thread(object: Runnable {
            override fun run() {
                setCandidatesViewShown(show)
            }
        })
    }

    fun set_pinyin(pinyin: String?) {
        if (pinyin != null) {
            _show_pinyin.set_text(pinyin)
            _show_pinyin(true)
        } else {
            _show_pinyin.set_text("")
            _show_pinyin(false)
        }
    }

    // export core
    fun core(): CoreInput = _core
}
