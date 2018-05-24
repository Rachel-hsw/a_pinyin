package org.sceext.a_pinyin.tool_word_count

import java.sql.Connection


class Eater {

    private fun _count_words(raw: String): Map<String, Int> {
        val o: MutableMap<String, Int> = mutableMapOf()
        for (i in raw.split("\n")) {  // for each line
            for (j in i.split(" ")) {  // for each word
                val one = j.trim()
                if (o.contains(one)) {
                    o[one] = o[one]!! + 1
                } else {
                    o[one] = 1
                }
            }
        }
        return o
    }

    private fun _update_db(data: Map<String, Int>, c: Connection) {
        // prepare statements
        val p_update = c.prepareStatement("UPDATE a_pinyin_data_word_count SET count = count + ? WHERE word = ?")
        val p_insert = c.prepareStatement("INSERT INTO a_pinyin_data_word_count(word, count) VALUES(?, ?)")

        // add each count
        for (entry in data) {
            // try UPDATE first
            p_update.setInt(1, entry.value)
            p_update.setString(2, entry.key)
            val r = p_update.executeUpdate()

            // if not exist, INSERT it
            if (r < 1) {
                p_insert.setString(1, entry.key)
                p_insert.setInt(2, entry.value)
                p_insert.executeUpdate()
            }
        }
    }


    fun feed(text: String, db: Connection) {
        val count = _count_words(text)

        // FIXME no TRANSACTIONs here to improve performance
        //db.autoCommit = false
        //try {
            _update_db(count, db)
        //    db.commit()
        //} catch (e: Exception) {
        //    db.rollback()
        //    throw e
        //}
    }
}
