package org.sceext.a_pinyin.core_symbol

import java.sql.Connection
import java.sql.PreparedStatement

import org.sceext.a_pinyin.core_util.copy


class BCoreSymbol2 {

    lateinit var _c: Connection  // user_data.db, table a_pinyin_user_symbol2
    lateinit var _conn: Connection  // core_data.db, table a_pinyin_symbol2

    // pre-compile SQL
    lateinit var _p_s: PreparedStatement  // SELECT
    lateinit var _p_u: PreparedStatement  // UPDATE
    lateinit var _p_i: PreparedStatement  // INSERT
    lateinit var _p_t: PreparedStatement  // for get Julian time

    // loaded data
    lateinit var _d_default: List<String>  // default data
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

    fun set_connection(conn: Connection, conn_user: Connection) {
        _c = conn_user
        _conn = conn
        // TODO support multi-list symbol2 ?

        // SELECT text, count, last_used
        _p_s = _c.prepareStatement("SELECT text, count, last_used FROM a_pinyin_user_symbol2")
        // UPDATE 1: count (count = count + ?), 2: last_used, 3: text
        _p_u = _c.prepareStatement("UPDATE a_pinyin_user_symbol2 SET count = count + ?, last_used = ? WHERE text = ?")
        // INSERT 1: text, 2: count, 3: last_used
        _p_i = _c.prepareStatement("INSERT INTO a_pinyin_user_symbol2(text, count, last_used) VALUES (?, ?, ?)")
        // SELECT julianday('now')
        _p_t = _c.prepareStatement("SELECT julianday('now')")

        // first load data
        _load_default_data(conn)
        _load_data()
    }

    // load default data from core_data.db
    private fun _load_default_data(c: Connection) {
        val p = c.prepareStatement("SELECT text FROM a_pinyin_symbol2 ORDER BY count DESC")
        val r = p.executeQuery()
        val default_list: MutableList<String> = mutableListOf()
        while (r.next()) {
            val text = r.getString(1)
            default_list.add(text)
        }
        _d_default = default_list
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

    // get symbol2 list (3)
    //   list 1: default list order by count
    //   list 2: sort by last_used
    //   list 3: sort by count
    fun get_list(): List<List<String>> {
        val o2: MutableList<String> = mutableListOf()
        for (i in _d_count) {
            o2.add(i.key)
        }
        val o3 = o2.copy()
        // sort
        o2.sortByDescending { i ->
            _d_lu[i]!!
        }
        o3.sortByDescending { i ->
            _d_count[i]!!
        }

        return listOf(_d_default, o2, o3)
    }

    // record user input
    fun on_input(text: String) {
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
