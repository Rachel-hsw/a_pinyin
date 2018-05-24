package org.sceext.a_pinyin.core_dict

import com.beust.klaxon.JsonObject
import com.beust.klaxon.JsonArray

import org.sceext.a_pinyin.core_util.BadDataFileException


class ACoreDictData {

    lateinit var char_to_pinyin: Map<Char, List<String>>

    // load `char_to_pinyin.json` file
    fun load_json(data: JsonObject) {
        try {
            _load(data)
        } catch (e: Exception) {
            throw BadDataFileException("bad char_to_pinyin.json file", e)
        }
    }

    fun _load(data: JsonObject) {
        val c2p: MutableMap<Char, List<String>> = mutableMapOf()
        for (i in data) {  // load each char
            val pinyin: MutableList<String> = mutableListOf()
            if (i.value is JsonArray<*>) {
                val l: JsonArray<String> = i.value as JsonArray<String>
                for (j in l) {
                    pinyin.add(j)
                }
            } else {
                pinyin.add(i.value as String)
            }
            c2p[i.key[0]] = pinyin
        }
        char_to_pinyin = c2p
    }
}
