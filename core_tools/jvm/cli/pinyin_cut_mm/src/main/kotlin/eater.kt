package org.sceext.a_pinyin.tool_pinyin_cut_mm

import com.beust.klaxon.JsonObject
import com.beust.klaxon.JsonArray
import com.beust.klaxon.json


class Eater {

    // if _last_pinyin is null, it means end
    var _last_pinyin: List<String>? = null

    // MM args

    // state transition probabilities
    lateinit var _A: Array<IntArray>
    // distribution of the initial state
    lateinit var _I: IntArray

    // for translate Chinese char to pinyin
    var _char_to_pinyin: MutableMap<Char, List<String>> = mutableMapOf()
    // for translate pinyin to int value
    var _pinyin_map: MutableMap<String, Int> = mutableMapOf()
    // 1 special symbol: (and its int value)
    //   + `E` (0): means END
    lateinit var _pinyin_sort: MutableList<String>

    fun load_char_to_pinyin(data: JsonObject) {
        for (c in data) {
            val one: MutableList<String> = mutableListOf()
            if (c.value is String) {
                val pinyin = c.value as String
                one.add(pinyin)
            } else {  // c.value is JsonArray
                val a: JsonArray<String> = c.value as JsonArray<String>
                for (i in a) {
                    one.add(i)
                }
            }
            _char_to_pinyin.put(c.key[0], one)
        }
    }

    fun load_pinyin_freq(data: JsonObject) {
        val pinyin_sort: JsonArray<String> = data.array("pinyin_sort")!!
        // load pinyin_sort
        _pinyin_sort = mutableListOf()
        for (i in pinyin_sort) {
            _pinyin_sort.add(i)
        }

        // add special symbol
        _pinyin_map.put("E", 0)

        var count = 1  // pinyin count start from 1

        for (i in _pinyin_sort) {
            _pinyin_map.put(i, count)
            count += 1
        }

        // init _A and _I
        val core_size = _pinyin_map.size
        _I = IntArray(core_size)
        _A = Array(core_size, { _ -> IntArray(core_size) })
    }

    fun export(): JsonObject {
        val I = json {
            array(_I.asList())
        }

        val a: MutableList<JsonArray<Any?>> = mutableListOf()
        for (i in _A) {
            a.add(json {
                array(i.asList())
            })
        }
        val A = json {
            array(a)
        }

        val pinyin_sort = json {
            array(_pinyin_sort)
        }

        val o = json {
            obj("pinyin_sort" to pinyin_sort,
                "I" to I,
                "A" to A )
        }
        return o
    }

    fun feed_char(c: Char) {
        // check char type
        if (! _char_to_pinyin.contains(c)) {
            feed_end()
            return
        }

        val pinyin = _char_to_pinyin[c]!!
        val last_pinyin = _last_pinyin
        // check first feed
        if (last_pinyin == null) {  // end state
            for (i in pinyin) {
                val i_pinyin = _get_pinyin_i(i)
                _I[i_pinyin] += 1
            }
        } else {  // next feed
            for (j in last_pinyin) {
                val i_last_pinyin = _get_pinyin_i(j)
                for (i in pinyin) {
                    val i_pinyin = _get_pinyin_i(i)
                    _A[i_last_pinyin][i_pinyin] += 1
                }
            }
        }
        // update _last_pinyin
        _last_pinyin = pinyin
    }

    fun _get_pinyin_i(s: String?): Int {
        if (s == null) {
            return 0  // E: 0
        }
        val o = _pinyin_map[s]
        if (o == null) {
            return 0
        } else {
            return o
        }
    }

    fun feed_end() {
        val last_pinyin = _last_pinyin
        if (last_pinyin == null) {
            return
        }
        for (i in last_pinyin) {
            val i_last_pinyin = _get_pinyin_i(i)
            _A[i_last_pinyin][0] += 1  // last_pinyin to end
        }
        _last_pinyin = null
    }
}
