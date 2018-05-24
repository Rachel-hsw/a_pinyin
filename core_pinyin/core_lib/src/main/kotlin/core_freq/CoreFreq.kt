package org.sceext.a_pinyin.core_freq

import org.sceext.a_pinyin.core_util.TextCount
import org.sceext.a_pinyin.core_util.UnknowPinyinException


const val MAX_LEVEL: Int = 4  // level A, B, C, D, E


class ACoreFreq {
    // read-only core data
    lateinit var _d: ACoreFreqData

    // load core data
    fun load_data(data: ACoreFreqData) {
        _d = data
    }

    // FIXME TODO fix order by count, char

    fun get_char(pinyin: String): List<List<TextCount>> {
        val chars = _d.pinyin_to_char[pinyin]
        if (chars == null) {
            throw UnknowPinyinException("unknow pinyin [${pinyin}]")
        }

        val o: MutableList<List<TextCount>> = mutableListOf()
        for (i in chars) {
            val one: MutableList<TextCount> = mutableListOf()
            for (j in i) {
                val c: String = j.toString()
                val count = if (_d.char_count[c] == null) 0 else _d.char_count[c]!!
                one.add(TextCount(c, count))
            }
            // TODO sort by char count ?
            o.add(one)
        }
        return o
    }
}
