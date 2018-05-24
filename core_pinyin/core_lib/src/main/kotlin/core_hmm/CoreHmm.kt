package org.sceext.a_pinyin.core_hmm

import org.sceext.a_pinyin.core_util.TextValue
import org.sceext.a_pinyin.core_util.CoreException
import org.sceext.a_pinyin.core_util.UnknowPinyinException


class ACoreHmm {
    // read-only core data
    lateinit var _d: ACoreHmmData

    fun load_data(data: ACoreHmmData) {
        _d = data
    }


    fun viterbi(pinyin: List<String>, n: Int = 1): List<TextValue> {
        val ip = _check_pinyin(pinyin)

        // check n
        if (n < 1) {
            throw Exception("bad n = ${n} < 1")
        } else if (n > 1) {
            return _viterbi_n(ip, n)
        } else {  // n == 1
            return listOf(_viterbi(ip))
        }
    }

    // TODO viterbi with pre str
    fun viterbi_r(pinyin: List<String>, pre: String): List<TextValue> {
        // TODO
        return listOf()
    }


    // check pinyin, and convert it to int list
    private fun _check_pinyin(pinyin: List<String>): IntArray {
        // check number of pinyin
        if (pinyin.size < 2) {  // at least need 2 pinyin for core HMM
            throw TooFewPinyinException("pinyin.size = ${pinyin.size} < 2")
        }

        val o: IntArray = IntArray(pinyin.size)
        // check unknow pinyin
        for (i in 0 until o.size) {
            val pinyin_i = _d.pinyin_map[pinyin[i]]
            if (pinyin_i == null) {
                throw UnknowPinyinException("unknow pinyin [${pinyin[i]}]")
            } else {
                o[i] = pinyin_i
            }
        }
        return o
    }

    // convert result int list to text
    private fun _result_to_str(result: IntArray): String {
        var o = ""
        for (i in result) {
            val c = _d.char_map[i]
            o += c
        }
        return o
    }

    // 1-best core viterbi
    private fun _viterbi(ip: IntArray): TextValue {
        val result_p: Array<DoubleArray> = Array(ip.size, { _ -> DoubleArray(_d.I.size) })  // state P
        val result_s: Array<IntArray> = Array(ip.size, { _ -> IntArray(_d.I.size) })  // pre state

        // step 0 result_p, for each state
        // LIMIT state visit by pinyin_to_char_i
        for (i in _d.pinyin_to_char_i[ip[0]]) {  // skip first `Ex`
            val start_p = _d.I[i].toDouble() / _d.count_I.toDouble()
            val emit_p = _d.B[ip[0]][i]
            result_p[0][i] = start_p * emit_p
        }
        // next steps, time t
        for (t in 1 until ip.size) {
            // for each state in time t
            // LIMIT state visit by pinyin_to_char_i
            for (s in _d.pinyin_to_char_i[ip[t]]) {  // current state
                for (s0 in _d.pinyin_to_char_i[ip[t - 1]]) {  // last state
                    val last_p = result_p[t - 1][s0]
                    val trans_p = _d.A[s0][s].toDouble() / _d.al[s0].toDouble()
                    val emit_p = _d.B[ip[t]][s]

                    val p = last_p * trans_p * emit_p
                    // keep one max p
                    if (p > result_p[t][s]) {
                        result_p[t][s] = p
                        result_s[t][s] = s0
                    }
                }
            }
        }
        // end core viterbi

        // gen result
        var last_p: Double = 0.0
        var last_s: Int = 0
        // find max last p
        var last_t = ip.size - 1
        for (s in 0 until _d.I.size) {
            val p = result_p[last_t][s]
            if (p > last_p) {
                last_p = p
                last_s = s
            }
        }
        val o = IntArray(ip.size)
        o[last_t] = last_s
        // get pre state
        while (last_t > 0) {
            last_s = result_s[last_t][last_s]
            last_t -= 1
            o[last_t] = last_s
        }

        return TextValue(_result_to_str(o), last_p)
    }

    // n-best viterbi
    private fun _viterbi_n(ip: IntArray, n: Int): List<TextValue> {
        // state P, result_p[i][j][k]: i time t, j n index, k state s
        val result_p: Array<Array<DoubleArray>> = Array(ip.size, { _ -> Array(n, { _ -> DoubleArray(_d.I.size) }) })
        // pre state, result_s[i][j][k]: i time t, j n index, k state s
        // FIX BUG for pinyin_to_char_i: result_s[i][j][k] = if (i > 0) 1 else 0
        val result_s: Array<Array<IntArray>> = Array(ip.size, { i -> Array(n, { _ -> IntArray(_d.I.size, { _ -> if (i > 0) 1 else 0 }) }) })
        // pre state index, result_i[i][j][k]: i time t, j n index, k state s
        // FIX BUG for pinyin_to_char_i: result_i[i][j][k] = if (i > 0) j else 0
        val result_i: Array<Array<IntArray>> = Array(ip.size, { i -> Array(n, { j -> IntArray(_d.I.size, { _ -> if (i > 0) j else 0 }) }) })

        // step 0, fill result_p, for each state
        // LIMIT state visit by pinyin_to_char_i
        for (i in _d.pinyin_to_char_i[ip[0]]) {  // skip first `Ex`
            val start_p = _d.I[i].toDouble() / _d.count_I.toDouble()
            val emit_p = _d.B[ip[0]][i]
            result_p[0][0][i] = start_p * emit_p
        }

        // next steps, time t
        for (t in 1 until ip.size) {
            // for each state in time t
            // LIMIT state visit by pinyin_to_char_i
            for (s in _d.pinyin_to_char_i[ip[t]]) {
                // for each pre state
                for (s0 in _d.pinyin_to_char_i[ip[t - 1]]) {
                    val trans_p = _d.A[s0][s].toDouble() / _d.al[s0].toDouble()
                    val emit_p = _d.B[ip[t]][s]

                    // for each n index
                    for (i in 0 until n) {
                        val last_p = result_p[t - 1][i][s0]
                        val p = last_p * trans_p * emit_p
                        // n-max
                        var j = n - 1
                        // check last insert
                        if (p <= result_p[t][j][s]) {
                            continue  // ignore this p, too small
                        }
                        // insert to last one
                        result_p[t][j][s] = p
                        result_s[t][j][s] = s0
                        result_i[t][j][s] = i
                        j -= 1
                        // rest (before) items, use bubble sort
                        while (j >= 0) {
                            if (result_p[t][j][s] >= result_p[t][j + 1][s]) {
                                break  // sort end
                            }
                            // exchange data
                            val tmp_p = result_p[t][j][s]
                            val tmp_s = result_s[t][j][s]
                            val tmp_i = result_i[t][j][s]
                            result_p[t][j][s] = result_p[t][j + 1][s]
                            result_s[t][j][s] = result_s[t][j + 1][s]
                            result_i[t][j][s] = result_i[t][j + 1][s]
                            result_p[t][j + 1][s] = tmp_p
                            result_s[t][j + 1][s] = tmp_s
                            result_i[t][j + 1][s] = tmp_i

                            j -= 1
                        }
                    }
                }
            }
        }
        // end core viterbi

        // gen result
        val max_p = DoubleArray(n)
        val max_s = IntArray(n)
        val max_i = IntArray(n)
        // n-max last p, for each state
        for (s in 0 until _d.I.size) {
            // for each n index
            for (i in 0 until n) {
                val p = result_p[ip.size - 1][i][s]
                // check last insert
                var j = n - 1
                if (p <= max_p[j]) {
                    continue
                }
                // insert to last one
                max_p[j] = p
                max_s[j] = s
                max_i[j] = i
                j -= 1
                // rest (before) items, use bubble sort
                while (j >= 0) {
                    if (max_p[j] >= max_p[j + 1]) {
                        break  // sort end
                    }
                    // exchange data
                    val tmp_p = max_p[j]
                    val tmp_s = max_s[j]
                    val tmp_i = max_i[j]
                    max_p[j] = max_p[j + 1]
                    max_s[j] = max_s[j + 1]
                    max_i[j] = max_i[j + 1]
                    max_p[j + 1] = tmp_p
                    max_s[j + 1] = tmp_s
                    max_i[j + 1] = tmp_i

                    j -= 1
                }
            }
        }

        // get pre state, and format output
        val o: MutableList<TextValue> = mutableListOf()
        for (i in 0 until n) {
            val one = IntArray(ip.size)
            var t: Int = ip.size - 1
            var last_s: Int = max_s[i]
            var last_i: Int = max_i[i]
            one[t] = last_s

            while (t > 0) {
                last_s = result_s[t][last_i][last_s]
                last_i = result_i[t][last_i][last_s]
                t -= 1
                one[t] = last_s
            }

            o.add(TextValue(_result_to_str(one), max_p[i]))
        }
        return o
    }
}


class TooFewPinyinException: CoreException {
    constructor(m: String): super(m)
    constructor(m: String, c: Throwable): super(m, c)
}
