package org.sceext.a_pinyin.core_pinyin_cut

import org.sceext.a_pinyin.core_util.copy


class ACorePinyinCut {
    // read-only core data
    lateinit var _d: ACorePinyinCutData

    // load core data
    fun load_data(data: ACorePinyinCutData) {
        _d = data
    }


    fun cut(raw: String): List<PinyinCutResult> {
        // check and clean pinyin char
        val p = StringBuilder()
        val q: MutableList<Int> = mutableListOf()  // index for `'` char
        for (c in raw.trim()) {
            if ((c >= 'a') and (c <= 'z')) {  // ok pinyin char
                p.append(c)
            } else if (c == '\'') {  // check special `'` char
                q.add(p.length)
                // TODO no need to ignore ' before all pinyin chars
            }
            // else: just ignore no-pinyin chars
        }
        // TODO check `'` cut with rest ?
        // TODO no need to ignore ' after all pinyin chars

        val r = _sort_with_mm(_depth_cut(p.toString()))
        // check cut `'`
        val o: MutableList<PinyinCutResult> = mutableListOf()
        for (one in r) {
            val cp: MutableSet<Int> = mutableSetOf()  // all cut positions
            var count = 0
            cp.add(count)
            for (i in one.pinyin) {
                count += i.length
                cp.add(count)
            }
            // check
            var bad_cut = false
            for (i in q) {
                if (! cp.contains(i)) {
                    bad_cut = true
                    break
                }
            }
            if (! bad_cut) {
                o.add(one)
            }
        }
        return o
    }

    // TODO support small keyboard pinyin input cut (12345678)
    fun cut_8(raw: String): List<PinyinCutResult> {
        // TODO
        return listOf()
    }


    fun _depth_cut(raw: String): List<PinyinCutResult> {
        var o: MutableList<PinyinCutResult> = mutableListOf()
        _cut_one(o, mutableListOf(), raw)

        // check result: if has no rest, drop all rest
        var no_rest = false
        for (r in o) {
            if (r.rest == null) {
                no_rest = true
                break
            }
        }
        if (no_rest) {
            o = o.filter {
                it.rest == null
            } as MutableList
        }
        return o
    }

    // TODO use loop to improve call stack
    fun _cut_one(o: MutableList<PinyinCutResult>, current: MutableList<String>, rest: String) {
        var can_cut = false
        for (i in _d.pinyin_sort) {
            // try to cut this pinyin
            if (rest.startsWith(i)) {
                val current_list = current.copy()
                current_list.add(i)

                _cut_one(o, current_list, rest.slice(i.length until rest.length))
                can_cut = true
            }
        }
        if (! can_cut) {
            var rest_str: String? = if (rest.length < 1) null else rest
            // add rest and finish cut
            val one = PinyinCutResult(current.copy(), rest_str, 0.0)
            o.add(one)
        }
    }

    // calc one MM P
    fun _calc_sort_value(pinyin: List<String>): Double {
        var value: Double
        // check pinyin list length
        if (pinyin.size < 1) {
            value = 0.0
        } else if (pinyin.size == 1) {
            val i = pinyin[0]
            value = _d.pinyin_freq[i]!!.toDouble() / _d.pinyin_freq_count.toDouble()
        } else {  // pinyin.size > 1
            // TODO use `log()` to calc

            var last_i = _d.pinyin_map[pinyin[0]]!!
            // first P
            value = _d.I[last_i].toDouble() / _d.count_I.toDouble()
            // next P
            for (i in 1 until pinyin.size) {
                val p_i = _d.pinyin_map[pinyin[i]]!!
                val next_p = _d.A[last_i][p_i].toDouble() / _d.al[last_i].toDouble()
                value *= next_p

                last_i = p_i
            }
        }
        return value
    }

    fun _sort_with_mm(raw: List<PinyinCutResult>): List<PinyinCutResult> {
        val o: MutableList<PinyinCutResult> = mutableListOf()
        for (i in raw) {
            o.add(PinyinCutResult(i.pinyin, i.rest, _calc_sort_value(i.pinyin)))
        }

        o.sortByDescending {
            it.sort_value
        }
        return o
    }
}


data class PinyinCutResult(val pinyin: List<String>, val rest: String?, val sort_value: Double)
