package org.sceext.a_pinyin

import java.io.InputStreamReader
import java.io.BufferedReader
import java.io.File

import android.os.Handler
import android.os.Looper
import android.widget.Toast

import com.beust.klaxon.Parser
import com.beust.klaxon.JsonObject
import com.beust.klaxon.JsonArray


fun run_on_ui_thread(to: Runnable) {
    val h = Handler(Looper.getMainLooper())
    h.post(to)
}

// show one toast on Android
fun toast(text: String) {
    // always run on UI thread
    run_on_ui_thread(object: Runnable {
        override fun run() {
            Toast.makeText(app_context(), text, Toast.LENGTH_SHORT).show()
        }
    })
}


fun parse_json(text: String): JsonObject {
    val b = StringBuilder(text)
    val parser = Parser()
    return parser.parse(b) as JsonObject
}

fun <T> parse_json_array(text: String): JsonArray<T> {
    val b = StringBuilder(text)
    val parser = Parser()
    return parser.parse(b) as JsonArray<T>
}

fun read_assets_text(filename: String): String {
    val a = app_context().getAssets()
    val r = BufferedReader(InputStreamReader(a.open(filename), "UTF-8"))
    var s: String? = r.readLine()
    val b = StringBuilder()
    while (s != null) {
        b.append(s)
        b.append('\n')

        s = r.readLine()
    }
    r.close()
    return b.toString()
}

fun read_file_text(filename: String): String {
    val f = File(filename)
    return f.readText()
}


fun send_native_event(data: JsonObject) {
    im_native?.send_event(data)  // ignore all error
}
