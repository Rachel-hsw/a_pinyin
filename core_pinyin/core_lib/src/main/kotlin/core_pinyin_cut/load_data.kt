package org.sceext.a_pinyin.core_pinyin_cut

import com.beust.klaxon.JsonObject
import com.beust.klaxon.JsonArray

import org.sceext.a_pinyin.core_util.BadDataFileException


class ACorePinyinCutData {
    // MM args
    lateinit var I: IntArray
    lateinit var A: Array<IntArray>
    // count for MM
    var count_I: Long = 0
    lateinit var al: IntArray

    // pinyin str to int value
    lateinit var pinyin_map: Map<String, Int>
    lateinit var pinyin_sort: List<String>

    // pinyin_freq and count
    lateinit var pinyin_freq: Map<String, Int>
    var pinyin_freq_count: Long = 0

    // load `core_pinyin_cut.json` file
    fun load_json(data: JsonObject) {
        try {
            _load(data)
        } catch (e: Exception) {
            throw BadDataFileException("bad core_pinyin_cut.json file", e)
        }
    }

    fun _load(data: JsonObject) {
        // load pinyin_sort
        val raw_ps: JsonArray<String> = data.array("pinyin_sort")!!
        val ps: MutableList<String> = mutableListOf()
        for (i in raw_ps) {
            ps.add(i)
        }
        pinyin_sort = ps

        // load I, A
        val raw_I: JsonArray<Int> = data.array("I")!!
        I = IntArray(raw_I.size)
        for (i in 0 until raw_I.size) {
            I[i] = raw_I[i]
        }
        val raw_A: JsonArray<JsonArray<Int>> = data.array("A")!!
        A = Array(raw_A.size, { _ -> IntArray(raw_A.size) })
        for (i in 0 until raw_A.size) {
            for (j in 0 until raw_A.size) {
                A[i][j] = raw_A[i][j]
            }
        }

        // load pinyin_freq
        val raw_pf: JsonObject = data.obj("pinyin_freq")!!
        val pf: MutableMap<String, Int> = mutableMapOf()
        for (entry in raw_pf) {
            pf.put(entry.key, entry.value as Int)
        }
        pinyin_freq = pf
        pinyin_freq_count = data.long("pinyin_freq_count")!!

        // gen pinyin_map
        val pm: MutableMap<String, Int> = mutableMapOf()
        // special symbol: 'E': 0
        var x = 1  // pinyin count start from 1
        for (p in pinyin_sort) {
            pm.put(p, x)
            x += 1
        }
        pinyin_map = pm

        // MM count
        count_I = 0
        for (i in I) {
            count_I += i
        }
        al = IntArray(A.size)
        for (i in 0 until A.size) {
            for (j in 0 until A[i].size) {
                al[i] += A[i][j]
            }
        }
    }
}
