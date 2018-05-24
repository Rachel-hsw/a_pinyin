package org.sceext.a_pinyin.core_symbol

import java.sql.Connection
import java.sql.PreparedStatement

import org.sceext.a_pinyin.core_util.copy


class BCoreSymbol {

    lateinit var _c: Connection  // user_data.db, table a_pinyin_user_symbol

    // pre-compile SQL
    lateinit var _p_s: PreparedStatement  // SELECT
    lateinit var _p_u: PreparedStatement  // UPDATE
    lateinit var _p_i: PreparedStatement  // INSERT
    lateinit var _p_t: PreparedStatement  // for get Julian time

    // loaded data
    lateinit var _d_count: MutableMap<String, Int>
    lateinit var _d_lu: MutableMap<String, Double>  // last_used
    // new changes
    lateinit var _n_count: MutableMap<String, Int>
    lateinit var _n_lu: MutableMap<String, Double>  // last_used

    fun get_julian_time_now(): Double {
        val r = _p_t.executeQuery()
        r.next()
        val o = r.getDouble(1)
        return o
    }

    // FIXME TODO fix order by last_used, count, text

    fun set_connection(conn: Connection) {
        _c = conn

        // SELECT text, count, last_used
        _p_s = _c.prepareStatement("SELECT text, count, last_used FROM a_pinyin_user_symbol")
        // UPDATE 1: count (count = count + ?), 2: last_used, 3: text
        _p_u = _c.prepareStatement("UPDATE a_pinyin_user_symbol SET count = count + ?, last_used = ? WHERE text = ?")
        // INSERT 1: text, 2: count, 3: last_used
        _p_i = _c.prepareStatement("INSERT INTO a_pinyin_user_symbol(text, count, last_used) VALUES (?, ?, ?)")
        // SELECT julianday('now')
        _p_t = _c.prepareStatement("SELECT julianday('now')")

        // first load data
        _load_data()
    }

    // load data from database
    private fun _load_data() {
        // reset loaded data
        _d_count = mutableMapOf()
        _d_lu = mutableMapOf()

        val r = _p_s.executeQuery()
        while (r.next()) {
            val text = r.getString(1)
            val count = r.getInt(2)
            val last_used = r.getDouble(3)

            _d_count[text] = count
            _d_lu[text] = last_used
        }

        // reset new changes
        _n_count = mutableMapOf()
        _n_lu = mutableMapOf()
    }

    // get symbol list (2)
    // first list: sort by last_used
    // second list: sort by count
    fun get_list(): List<List<String>> {
        val o1: MutableList<String> = mutableListOf()
        for (i in _d_count) {
            o1.add(i.key)
        }
        val o2 = o1.copy()
        // sort
        o1.sortByDescending { i ->
            _d_lu[i]!!
        }
        o2.sortByDescending { i ->
            _d_count[i]!!
        }

        return listOf(o1, o2)
    }

    // record user input
    fun on_input(text: String) {
        // assert: text.length == 1

        // update loaded data
        var count = if (_d_count.contains(text)) _d_count[text]!! else 0
        count += 1
        _d_count[text] = count

        // update new changes
        count = if (_n_count.contains(text)) _n_count[text]!! else 0
        count += 1
        _n_count[text] = count

        // update last_used
        _d_lu[text] = get_julian_time_now()
        _n_lu[text] = get_julian_time_now()
    }

    // save changes in database
    fun commit_changes() {
        // begin transaction
        _c.autoCommit = false

        for (entry in _n_count) {
            val text = entry.key
            val count = entry.value
            val last_used = _n_lu[text]!!
            // try update first
            _p_u.setInt(1, count)
            _p_u.setDouble(2, last_used)
            _p_u.setString(3, text)
            val r = _p_u.executeUpdate()
            // if not exist, INSERT it
            if (r < 1) {
                _p_i.setString(1, text)
                _p_i.setInt(2, count)
                _p_i.setDouble(3, last_used)
                _p_i.executeUpdate()
            }
        }
        // TODO error process ?
        // commit
        _c.commit()
        _c.autoCommit = true

        _load_data()
    }
}
