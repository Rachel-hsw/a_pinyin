package org.sceext.a_pinyin.core_mix

import kotlin.math.min

import org.sceext.a_pinyin.core_util.TextCount
import org.sceext.a_pinyin.core_util.TextValue
import org.sceext.a_pinyin.core_util.CoreException
import org.sceext.a_pinyin.core_util.UnknowPinyinException
import org.sceext.a_pinyin.core_freq.MAX_LEVEL
import org.sceext.a_pinyin.core_freq.ACoreFreq
import org.sceext.a_pinyin.core_hmm.ACoreHmm
import org.sceext.a_pinyin.core_hmm.TooFewPinyinException
import org.sceext.a_pinyin.core_dict.ACoreDict
import org.sceext.a_pinyin.core_user.BCoreUser
import org.sceext.a_pinyin.core_user.CoreUserList


// TODO support core_mix load data ?
// TODO external policy with load data ?
// core_user is optional
class ACoreMix(val core_freq: ACoreFreq, val core_hmm: ACoreHmm, val core_dict: ACoreDict, val core_user: BCoreUser? = null) {

    // config level for core_freq
    private var _level: Int = 0

    // first N items from core_user order by last_used
    private var _user_last_used_n: Int = 10  // TODO support config this value ?

    fun set_level(level: Int) {
        _level = level
    }

    fun get_level() = _level


    fun <T> clean_list(raw: List<List<T>>, at_least: Int = 2): List<List<T>> {
        // only add no-empty list
        val o: MutableList<List<T>> = mutableListOf()
        for (i in raw) {
            if (i.size > 0) {
                o.add(i)
            }
        }
        // return at least 2 (default) list, even empty
        while (o.size < at_least) {
            o.add(listOf())
        }
        return o
    }


    private fun _q_freq(pinyin: List<String>): List<List<TextCount>> {
        // TODO UnknowPinyinException ?
        val r = core_freq.get_char(pinyin[0])
        // check level
        val o: MutableList<List<TextCount>> = mutableListOf()
        var count = 0
        var i = 0
        while ((i <= _level) or (count < 1)) {
            val one = r[i]
            o.add(one)
            i += 1
            count += one.size
        }
        return clean_list(o)
    }

    private fun _q_hmm(pinyin: List<String>): List<TextValue> {
        if (pinyin.size < 2) {
            return listOf()
        }
        // check pinyin.size for n
        // TODO policy with load data ?
        var n = 5  // default: n = 5
        if (pinyin.size > 4) {  // TODO 4 ?
            n = 2
        }
        if (pinyin.size > 7) {  // TODO 7 ?
            n = 1
        }
        // process UnknowPinyinException
        val r: List<TextValue>
        try {
            r = core_hmm.viterbi(pinyin, n)
        } catch (e: UnknowPinyinException) {
            // just ignore it, no log here
            return listOf()
        }
        // remove 'x' in result
        val o: MutableList<TextValue> = mutableListOf()
        for (i in r) {
            if (i.text.indexOf("x") == -1) {
                o.add(i)
            }
        }
        return o
    }

    private fun _q_dict(pinyin: List<String>): List<TextCount> {
        // TODO support prefix words ?
        return core_dict.get_words(pinyin)
    }

    private fun _split_dict(raw: List<TextCount>): List<List<TextCount>> {
        // split by count to 2 list
        val o: List<MutableList<TextCount>> = listOf(mutableListOf(), mutableListOf())
        val split_value = 1000  // TODO 1000 ?
        for (i in raw) {  // already sorted
            if (i.count > split_value) {
                o[0].add(i)
            } else {
                o[1].add(i)
            }
        }
        return o
    }

    // core_user dict, NO pinyin.length > 1 limit !
    private fun _q_user_dict(pinyin: List<String>): List<TextValue> {
        if (core_user == null) {
            return listOf()
        }
        val r = core_user.get_dict(pinyin)
        if (r == null) {
            return listOf()
        }
        return _core_user_merge_result(r)
    }

    private fun _q_user_freq(pinyin: List<String>): List<TextValue> {
        if (core_user == null) {
            return listOf()
        }
        val r = core_user.get_char_freq(pinyin[0])  // use first pinyin
        if (r == null) {
            return listOf()
        }
        return _core_user_merge_result(r)
    }

    private fun _core_user_merge_result(r: CoreUserList): List<TextValue> {
        // merge 2 lists: last_used, count
        val o: MutableList<TextValue> = mutableListOf()
        for (i in 0 until min(_user_last_used_n, r.u.size)) {
            o.add(r.u[i])
        }
        // add all count here, before clean_list
        for (i in r.c) {
            o.add(TextValue(i.text, i.count.toDouble()))
        }
        return o
    }

    // get text list from pinyin
    fun get_text(pinyin: List<String>): List<List<String>> {
        // check pinyin length
        if (pinyin.size < 1) {
            return listOf()
        }
        // query each sub core module
        val r_freq = _q_freq(pinyin)
        val r_hmm = _q_hmm(pinyin)  // TODO use multi-thread, especially for CoreHmm ?
        val r_dict = _q_dict(pinyin)
        // user model
        val r_user_dict = _q_user_dict(pinyin)
        val r_user_freq = _q_user_freq(pinyin)

        // TODO better merge policy ?
        // merge result
        // TODO same items get higher priority ?
        // merge order:
        //  + user_dict
        //  + same (hmm, dict)
        //  + dict  // dict before HMM
        //  + hmm
        //  + user_freq
        //  + freq

        // 2 empty result list
        val o: MutableList<MutableList<String>> = mutableListOf(mutableListOf(), mutableListOf())
        // user_dict
        for (i in r_user_dict) {
            o[0].add(i.text)
        }

        // same (hmm, dict)
        val same: MutableList<String> = mutableListOf()
        val rest_hmm: MutableList<String> = mutableListOf()
        val rest_dict: MutableList<TextCount> = mutableListOf()
        val hmm_set: MutableSet<String> = mutableSetOf()
        for (i in r_hmm) {
            hmm_set.add(i.text)
        }
        for (i in r_dict) {
            if (hmm_set.contains(i.text)) {
                same.add(i.text)
            } else {
                rest_dict.add(i)
            }
        }
        for (i in r_hmm) {
            if (! same.contains(i.text)) {
                rest_hmm.add(i.text)
            }
        }
        val s_dict = _split_dict(rest_dict)

        o[0].addAll(same)  // same (hmm, dict)

        // dict
        for (i in 0..1) {
            for (j in s_dict[i]) {
                o[i].add(j.text)
            }
        }
        o[0].addAll(rest_hmm)  // hmm after dict

        // user_freq
        for (i in r_user_freq) {
            o[0].add(i.text)
        }
        // freq
        for (i in 0..1) {
            for (j in r_freq[i]) {
                o[i].add(j.text)
            }
        }
        // rest of freq
        for (i in 2 until r_freq.size) {
            val one: MutableList<String> = mutableListOf()
            for (j in r_freq[i]) {
                one.add(j.text)
            }
            o.add(one)
        }

        // remove same items in list
        val s: MutableSet<String> = mutableSetOf()
        val r: MutableList<List<String>> = mutableListOf()
        for (i in o) {
            val one: MutableList<String> = mutableListOf()
            for (j in i) {
                if (! s.contains(j)) {
                    one.add(j)
                    s.add(j)
                }
            }
            r.add(one)
        }
        return clean_list(r, 0)
    }
}
