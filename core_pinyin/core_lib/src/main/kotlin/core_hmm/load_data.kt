package org.sceext.a_pinyin.core_hmm

import com.beust.klaxon.JsonObject
import com.beust.klaxon.JsonArray

import org.sceext.a_pinyin.core_util.BadDataFileException


class ACoreHmmData {

    // convert pinyin str to int value (observations)
    lateinit var pinyin_map: Map<String, Int>
    // convert result int value (states) to chars
    lateinit var char_map: String  // first 2 chars is `Ex`

    // HMM args
    lateinit var I: IntArray  // start probability
    lateinit var A: Array<IntArray>  // transition probability
    lateinit var B: Array<IntArray>  // emission probability

    // count for HMM
    var count_I: Long = 0
    lateinit var al: IntArray

    // for speed up viterbi
    lateinit var pinyin_to_char_i: Array<IntArray>

    // load `core_hmm.json`
    fun load_json(data: JsonObject) {
        try {
            _load(data)
        } catch (e: Exception) {
            throw BadDataFileException("bad core_hmm.json file", e)
        }
    }

    fun _load(data: JsonObject) {
        // load char_map
        char_map = data.string("char_map")!!

        // load pinyin_sort
        val raw_ps: JsonArray<String> = data.array("pinyin_sort")!!
        val ps: MutableList<String> = mutableListOf()
        for (i in raw_ps) {
            ps.add(i)
        }
        // gen pinyin_map
        val pm: MutableMap<String, Int> = mutableMapOf()
        for (i in 0 until ps.size) {
            val pinyin = ps[i]
            pm[pinyin] = i
        }
        pinyin_map = pm

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
        // count I, A
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

        // load char_to_pinyin
        val raw_cp = data.obj("char_to_pinyin")!!
        val cp: MutableMap<Char, List<String>> = mutableMapOf()
        for (i in raw_cp) {
            val c = i.key[0]
            val raw_p: JsonArray<String> = i.value as JsonArray<String>
            val pinyin: MutableList<String> = mutableListOf()
            for (p in raw_p) {
                pinyin.add(p)
            }
            cp[c] = pinyin
        }

        // gen B[i][j]: i -> pinyin_i, j -> char_i
        B = Array(ps.size, { _ -> IntArray(char_map.length) })
        for (j in 2 until char_map.length) {
            val c = char_map[j]
            val pinyin_list = cp[c]!!

            for (k in pinyin_list) {
                val i = pinyin_map[k]!!
                B[i][j] = 1  // default value: 0
            }
        }

        // gen pinyin_to_char_i[i]: i -> pinyin_i, -> char_i
        val pinyin_to_char_i_len = IntArray(B.size)
        for (i in 0 until B.size) {
            for (j in B[i]) {
                if (j > 0) {
                    pinyin_to_char_i_len[i] += 1
                }
            }
        }
        pinyin_to_char_i = Array(B.size, { i -> IntArray(pinyin_to_char_i_len[i])})
        for (i in 0 until B.size) {
            // fill no-0 index
            var c = 0
            for (j in 0 until B[i].size) {
                if (B[i][j] > 0) {
                    pinyin_to_char_i[i][c] = j
                    c += 1
                }
            }
        }
    }
}
