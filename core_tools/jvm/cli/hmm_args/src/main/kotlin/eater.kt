package org.sceext.a_pinyin.tool_hmm_args

import com.beust.klaxon.JsonObject
import com.beust.klaxon.JsonArray
import com.beust.klaxon.json


class Eater {

    // if _last_char is null, it means end
    var _last_char: Char? = null

    // HMM args

    // state transition probabilities
    lateinit var _A: Array<IntArray>
    // distribution of the initial state
    lateinit var _I: IntArray

    // for check all Chinese chars
    var _chinese_char: MutableSet<Char> = mutableSetOf()
    // for translate chinese char to int value
    var _char_map: MutableMap<Char, Int> = mutableMapOf()
    // 2 special chars: (and its int value)
    //   + `E` (0): means END
    //   + `x` (1): means other Chinese chars not in this model set
    lateinit var _char_map_string: String

    fun load_char_sort(data: JsonObject) {
        // load chars of all classes in _chinese_char
        for (i in arrayOf("a", "b", "c", "d", "e")) {
            val text = data.string(i)!!
            for (c in text) {
                _chinese_char.add(c)
            }
        }
        // NOTE only add chars of class A in _char_map
        val text = data.string("a")!!
        // _char_map_string, not forget 2 special chars
        _char_map_string = "Ex" + text

        var i = 2  // the int value of first chinese char is 2
        for (c in text) {
            _char_map.put(c, i)
            i += 1
        }

        // init _A and _I
        val core_size = _char_map_string.length
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
        val o = json {
            obj("char_map" to _char_map_string,
                "I" to I,
                "A" to A )
        }
        return o
    }

    fun feed_char(c: Char) {
        // check char type
        if (! _chinese_char.contains(c)) {
            feed_end()
            return
        }
        // check `x` char
        val ch = if (_char_map.contains(c)) c else 'x'
        val i_char = _get_char_i(ch)
        // check first feed
        if (_last_char == null) {  // end state
            _I[i_char] += 1
        } else {  // next feed
            val i_last_char = _get_char_i(_last_char)
            _A[i_last_char][i_char] += 1
        }
        // update _last_char
        _last_char = ch
    }

    fun _get_char_i(c: Char?): Int {
        if (c == null) {
            return 0  // E: 0
        }
        return when(c) {
            'E' -> 0
            'x' -> 1
            else -> _char_map[c]!!
        }
    }

    fun feed_end() {
        if (_last_char == null) {
            return
        }
        val i_last_char = _get_char_i(_last_char)
        // add 1 count to _A
        _A[i_last_char][0] += 1  // last_char to end

        _last_char = null
    }
}
