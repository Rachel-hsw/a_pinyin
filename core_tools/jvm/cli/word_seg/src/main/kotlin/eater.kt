package org.sceext.a_pinyin.tool_word_seg

import com.beust.klaxon.JsonObject
import com.hankcs.hanlp.model.crf.CRFSegmenter


class Eater {

    // Chinese char set
    private lateinit var _s: MutableSet<Char>

    private var _seg: CRFSegmenter

    init {
        // init word seg for HanLP
        _seg = CRFSegmenter()
    }


    fun load_char_sort(data: JsonObject) {
        _s = mutableSetOf()
        // load all 'a b c d e' class chars
        for (l in listOf("a", "b", "c", "d", "e")) {
            val a = data.string(l)!!
            for (c in a) {
                _s.add(c)
            }
        }
    }


    fun feed(text: String): String {
        val o = StringBuilder()

        var b = StringBuilder()
        for (c in text) {
            // check char type
            if (_s.contains(c)) {
                b.append(c)
            } else if (b.length > 0) {
                _one_seg(b.toString(), o)
                // reset buffer
                b = StringBuilder()
            }
        }
        // check feed end
        if (b.length > 0) {
            _one_seg(b.toString(), o)
        }
        return o.toString()
    }

    private fun _one_seg(raw: String, o: StringBuilder) {
        val result = _word_seg(raw)
        o.append(result.joinToString(" "))
        o.append("\n")
    }

    // TODO support named entity ?
    private fun _word_seg(raw: String): List<String> {
        return _seg.segment(raw)
    }
}
