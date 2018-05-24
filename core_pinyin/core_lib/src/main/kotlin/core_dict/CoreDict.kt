package org.sceext.a_pinyin.core_dict

import java.sql.Connection
import java.sql.PreparedStatement

import org.sceext.a_pinyin.core_util.TextCount


class ACoreDict {
    // read-only core data
    lateinit var _d: ACoreDictData

    lateinit var _c: Connection
    // pre-complie SQL
    lateinit var _p_s: PreparedStatement

    // load core data
    fun load_data(data: ACoreDictData) {
        _d = data
    }

    fun set_connection(c: Connection) {
        _c = c

        // fix order by count, word
        // pre-compile SQL: (1: pin_yin, 2: length(word))
        _p_s = _c.prepareStatement("SELECT word, count FROM a_pinyin_core_dict, a_pinyin_core_dict_pinyin WHERE (a_pinyin_core_dict.prefix2 = a_pinyin_core_dict_pinyin.prefix2) AND (pin_yin = ?) AND (length(word) = ?) ORDER BY count DESC, word")
    }


    fun get_words(pinyin: List<String>): List<TextCount> {
        // check pinyin length
        if (pinyin.size < 2) {
            return listOf()
        }
        // pin_yin for first 2 chars prefix
        val pin_yin = pinyin.slice(0 until 2).joinToString("_")
        _p_s.setString(1, pin_yin)
        _p_s.setInt(2, pinyin.size)

        val r = _p_s.executeQuery()
        val o: MutableList<TextCount> = mutableListOf()
        while (r.next()) {
            val word = r.getString(1)
            val count = r.getInt(2)
            if (_check_pinyin(pinyin, word)) {
                o.add(TextCount(word, count))
            }
        }
        return o
    }

    // return true if pinyin match the word
    private fun _check_pinyin(pinyin: List<String>, word: String): Boolean {
        // check length first
        if (pinyin.size != word.length) {
            return false
        }
        // check each char
        for (i in 0 until word.length) {  // TODO not check first 2 chars ?
            val l = _d.char_to_pinyin[word[i]]!!
            var pinyin_ok = false
            for (j in l) {
                if (j == pinyin[i]) {
                    pinyin_ok = true
                    break
                }
            }
            if (! pinyin_ok) {
                return false
            }
        }  // check pass
        return true
    }
}
