package org.sceext.a_pinyin.core_freq

import com.beust.klaxon.JsonObject

import org.sceext.a_pinyin.core_util.BadDataFileException


class ACoreFreqData {

    var meta_char: Int = 0
    var meta_count: Int = 0
    var char_count: Map<String, Int> = mapOf()
    var pinyin_to_char: Map<String, List<String>> = mapOf()

    // load `core_freq.json` file
    fun load_json(data: JsonObject) {
        try {
            _load(data)
        } catch (e: Exception) {
            throw BadDataFileException("bad core_freq.json file", e)
        }
    }

    fun _load(data: JsonObject) {
        // char_count
        val raw_cc = data.obj("char_count")!!
        meta_char = raw_cc.int("char")!!
        meta_count = raw_cc.int("count")!!
        val raw_data = raw_cc.obj("data")!!
        val cc: MutableMap<String, Int> = mutableMapOf()
        for (i in raw_data) {
            cc[i.key] = i.value as Int
        }
        char_count = cc

        // pinyin_to_char
        val raw_p = data.obj("pinyin_to_char")!!
        val p2c: MutableMap<String, List<String>> = mutableMapOf()
        for (i in raw_p) {
            val chars: MutableList<String> = mutableListOf()
            for (t in listOf("a", "b", "c", "d", "e")) {
                val c = (i.value as JsonObject).string(t)
                if (c == null) {
                    chars.add("")
                } else {
                    chars.add(c)
                }
            }
            p2c[i.key] = chars
        }
        pinyin_to_char = p2c
    }
}
