package org.sceext.a_pinyin

import android.content.Context
import android.view.View
import android.widget.TextView


const val SHOW_PINYIN_PADDING: Int = 5
const val SHOW_PINYIN_COLOR: Int = -1  // 0xff_ff_ff_ff
const val SHOW_PINYIN_BG: Int = -2147483648  // 0x80_00_00_00
const val SHOW_PINYIN_SIZE: Float = 20.0f

class ShowPinyin {
    lateinit var _text: TextView

    fun get_view(context: Context): View {
        _text = TextView(context)
        _text.setPadding(SHOW_PINYIN_PADDING, SHOW_PINYIN_PADDING,
            SHOW_PINYIN_PADDING, SHOW_PINYIN_PADDING)
        _text.setTextColor(SHOW_PINYIN_COLOR)
        _text.setTextSize(SHOW_PINYIN_SIZE)
        _text.setBackgroundColor(SHOW_PINYIN_BG)

        return _text
    }

    fun set_text(text: String) {
        run_on_ui_thread(object: Runnable {
            override fun run() {
                _text.setText(text)
            }
        })
    }
}
