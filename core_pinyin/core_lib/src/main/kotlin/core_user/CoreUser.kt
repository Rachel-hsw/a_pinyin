package org.sceext.a_pinyin.core_user

import java.sql.Connection
import java.sql.PreparedStatement

import org.sceext.a_pinyin.core_util.TextCount
import org.sceext.a_pinyin.core_util.TextValue
import org.sceext.a_pinyin.core_util.make_inmemory_db


class BCoreUser {
    lateinit var _c: Connection  // user_data.db
    // tables: a_pinyin_user_dict, a_pinyin_user_char_freq
    // pre-compile SQL
    lateinit var _p_t: PreparedStatement  // for get Julian time

    // full query to load data in cache
    lateinit var _p_sd: PreparedStatement  // query a_pinyin_user_dict
    lateinit var _p_sf: PreparedStatement  // query a_pinyin_user_char_freq
    lateinit var _p_ud: PreparedStatement  // update a_pinyin_user_dict
    lateinit var _p_uf: PreparedStatement  // update a_pinyin_user_char_freq
    lateinit var _p_id: PreparedStatement  // insert a_pinyin_user_dict
    lateinit var _p_if: PreparedStatement  // insert a_pinyin_user_char_freq

    // in-memory sqlite3 database, used for cache and keep new changes
    // tables to store cached data: cache_dict, cache_freq
    // tables to store new changes: n_dict, n_freq
    lateinit var _cm: Connection
    lateinit var _pm_dcd: PreparedStatement  // DELETE FROM cache_dict
    lateinit var _pm_dcf: PreparedStatement  // DELETE FROM cache_freq
    lateinit var _pm_dnd: PreparedStatement  // DELETE FROM n_dict
    lateinit var _pm_dnf: PreparedStatement  // DELETE FROM n_freq
    // for cache
    lateinit var _pm_sd_c: PreparedStatement  // query cache_dict, order by count
    lateinit var _pm_sf_c: PreparedStatement  // query cache_freq, order by count
    lateinit var _pm_sd_l: PreparedStatement  // query cache_dict, order by last_used
    lateinit var _pm_sf_l: PreparedStatement  // query cache_freq, order by last_used
    lateinit var _pm_ud: PreparedStatement  // update cache_dict
    lateinit var _pm_uf: PreparedStatement  // update cache_freq
    // FIXME TODO should cache allow insert ?
    lateinit var _pm_id: PreparedStatement  // insert cache_dict
    lateinit var _pm_if: PreparedStatement  // insert cache_freq
    // for new changes
    lateinit var _pn_sd: PreparedStatement  // query n_dict
    lateinit var _pn_sf: PreparedStatement  // query n_freq
    lateinit var _pn_ud: PreparedStatement  // update n_dict
    lateinit var _pn_uf: PreparedStatement  // update n_freq
    lateinit var _pn_id: PreparedStatement  // insert n_dict
    lateinit var _pn_if: PreparedStatement  // insert n_freq

    fun get_julian_time_now(): Double {
        val r = _p_t.executeQuery()
        r.next()
        val o = r.getDouble(1)
        return o
    }

    fun set_connection(c: Connection) {
        _c = c
        // FIXME: when to close and release this database ?
        _cm = _init_inmemory_db()

        _pm_dcd = _cm.prepareStatement("DELETE FROM cache_dict")
        _pm_dcf = _cm.prepareStatement("DELETE FROM cache_freq")
        _pm_dnd = _cm.prepareStatement("DELETE FROM n_dict")
        _pm_dnf = _cm.prepareStatement("DELETE FROM n_freq")

        // fix order by last_used, count, text

        // SELECT text, count FROM cache_dict
        // 1: pin_yin; order by count
        _pm_sd_c = _cm.prepareStatement("SELECT text, count FROM cache_dict WHERE pin_yin = ? ORDER BY count DESC, last_used DESC, text")
        // SELECT char, count FROM cache_freq
        // 1: pinyin; order by count
        _pm_sf_c = _cm.prepareStatement("SELECT char, count FROM cache_freq WHERE pinyin = ? ORDER BY count DESC, last_used DESC, char")
        // SELECT text, last_used FROM cache_dict
        // 1: pin_yin; order by last_used
        _pm_sd_l = _cm.prepareStatement("SELECT text, last_used FROM cache_dict WHERE pin_yin = ? ORDER BY last_used DESC, count DESC, text")
        // SELECT char, last_used FROM cache_freq
        // 1: pinyin; order by last_used
        _pm_sf_l = _cm.prepareStatement("SELECT char, last_used FROM cache_freq WHERE pinyin = ? ORDER BY last_used DESC, count DESC, char")

        // UPDATE cache_dict
        // 1: count = count + ?, 2: last_used, 3: text, 4: pin_yin
        _pm_ud = _cm.prepareStatement("UPDATE cache_dict SET count = count + ?, last_used = ? WHERE (text = ?) AND (pin_yin = ?)")
        // UPDATE cache_freq
        // 1: count = count + ?, 2: last_used, 3: char, 4: pinyin
        _pm_uf = _cm.prepareStatement("UPDATE cache_freq SET count = count + ?, last_used = ? WHERE (char = ?) AND (pinyin = ?)")
        // INSERT INTO cache_dict
        // VALUES (text, pin_yin, pinyin, count, last_used)
        _pm_id = _cm.prepareStatement("INSERT INTO cache_dict (text, pin_yin, pinyin, count, last_used) VALUES (?, ?, ?, ?, ?)")
        // INSERT INTO cache_freq
        // VALUES (char, pinyin, count, last_used)
        _pm_if = _cm.prepareStatement("INSERT INTO cache_freq (char, pinyin, count, last_used) VALUES (?, ?, ?, ?)")

        // SELECT text, pin_yin, pinyin, count, last_used FROM n_dict
        _pn_sd = _cm.prepareStatement("SELECT text, pin_yin, pinyin, count, last_used FROM n_dict")
        // SELECT char, pinyin, count, last_used FROM n_freq
        _pn_sf = _cm.prepareStatement("SELECT char, pinyin, count, last_used FROM n_freq")

        // UPDATE n_dict
        // 1: count = count + ?, 2: last_used, 3: text, 4: pin_yin
        _pn_ud = _cm.prepareStatement("UPDATE n_dict SET count = count + ?, last_used = ? WHERE (text = ?) AND (pin_yin = ?)")
        // UPDATE n_freq
        // 1: count = count + ?, 2: last_used, 3: char, 4: pinyin
        _pn_uf = _cm.prepareStatement("UPDATE n_freq SET count = count + ?, last_used = ? WHERE (char = ?) AND (pinyin = ?)")
        // INSERT INTO n_dict
        // VALUES (text, pin_yin, pinyin, count, last_used)
        _pn_id = _cm.prepareStatement("INSERT INTO n_dict (text, pin_yin, pinyin, count, last_used) VALUES (?, ?, ?, ?, ?)")
        // INSERT INTO n_freq
        // VALUES (char, pinyin, count, last_used)
        _pn_if = _cm.prepareStatement("INSERT INTO n_freq (char, pinyin, count, last_used) VALUES (?, ?, ?, ?)")

        // SELECT julianday('now')
        _p_t = _cm.prepareStatement("SELECT julianday('now')")

        // SELECT text, count, last_used FROM a_pinyin_user_dict
        // 1: pin_yin
        _p_sd = _c.prepareStatement("SELECT text, count, last_used FROM a_pinyin_user_dict WHERE pin_yin = ?")
        // SELECT char, count, last_used FROM a_pinyin_user_char_freq
        // 1: pinyin
        _p_sf = _c.prepareStatement("SELECT char, count, last_used FROM a_pinyin_user_char_freq WHERE pinyin = ?")

        // UPDATE a_pinyin_user_dict
        // 1: count = count + ?, 2: last_used, 3: text, 4: pin_yin
        _p_ud = _c.prepareStatement("UPDATE a_pinyin_user_dict SET count = count + ?, last_used = ? WHERE (text = ?) AND (pin_yin = ?)")
        // UPDATE a_pinyin_user_char_freq
        // 1: count = count + ?, 2: last_used, 3: char, 4: pinyin
        _p_uf = _c.prepareStatement("UPDATE a_pinyin_user_char_freq SET count = count + ?, last_used = ? WHERE (char = ?) AND (pinyin = ?)")
        // INSERT INTO a_pinyin_user_dict
        // VALUES (text, pin_yin, pinyin, count, last_used)
        _p_id = _c.prepareStatement("INSERT INTO a_pinyin_user_dict (text, pin_yin, pinyin, count, last_used) VALUES (?, ?, ?, ?, ?)")
        // INSERT INTO a_pinyin_char_freq
        // VALUES (char, pinyin, count, last_used)
        _p_if = _c.prepareStatement("INSERT INTO a_pinyin_user_char_freq (char, pinyin, count, last_used) VALUES (?, ?, ?, ?)")

        _reset_new_changes()
    }

    private fun _init_inmemory_db(): Connection {
        val c = make_inmemory_db()
        // create tables, ignore NOT NULL, etc.
        c.prepareStatement("CREATE TABLE cache_dict (text TEXT, pin_yin TEXT, pinyin TEXT, count INT, last_used REAL, PRIMARY KEY (text, pin_yin)) WITHOUT ROWID").execute()
        c.prepareStatement("CREATE TABLE cache_freq (char TEXT, pinyin TEXT, count INT, last_used REAL, PRIMARY KEY (char, pinyin)) WITHOUT ROWID").execute()
        c.prepareStatement("CREATE TABLE n_dict (text TEXT, pin_yin TEXT, pinyin TEXT, count INT, last_used REAL, PRIMARY KEY (text, pin_yin)) WITHOUT ROWID").execute()
        c.prepareStatement("CREATE TABLE n_freq (char TEXT, pinyin TEXT, count INT, last_used REAL, PRIMARY KEY (char, pinyin)) WITHOUT ROWID").execute()

        // TODO create index ?
        //c.prepareStatement("CREATE INDEX ").execute()
        return c
    }

    private fun _reset_new_changes() {
        // delete data from all in-memory db tables
        _pm_dcd.executeUpdate()
        _pm_dcf.executeUpdate()
        _pm_dnd.executeUpdate()
        _pm_dnf.executeUpdate()
    }

    private fun _join_pin_yin(pinyin: List<String>): String {
        return pinyin.joinToString("_")
    }

    private fun _join_pinyin(pinyin: List<String>): String {
        return pinyin.joinToString("")
    }

    private fun _split_pin_yin(pin_yin: String): List<String> {
        return pin_yin.split("_")
    }

    // load data in cache_freq
    // return true if not load empty data
    private fun _load_data_freq(pinyin: String): Boolean {
        // assert: no data in cache, just INSERT
        // TODO what about transaction for in-memory database ?
        _p_sf.setString(1, pinyin)
        val r = _p_sf.executeQuery()
        if (! r.isBeforeFirst()) {
            return false  // no data to load
        }
        while (r.next()) {
            val char = r.getString(1)
            val count = r.getInt(2)
            val last_used = r.getDouble(3)
            _pm_if.setString(1, char)
            _pm_if.setString(2, pinyin)
            _pm_if.setInt(3, count)
            _pm_if.setDouble(4, last_used)
            _pm_if.executeUpdate()
        }
        return true
    }

    // load data in cache_dict
    // return true if not load empty data
    private fun _load_data_dict(pin_yin: String, pinyin: String): Boolean {
        // assert: no data in cache, just INSERT
        // TODO what about transaction for in-memory database ?
        _p_sd.setString(1, pin_yin)
        val r = _p_sd.executeQuery()
        if (! r.isBeforeFirst()) {
            return false  // no data to load
        }
        while (r.next()) {
            val text = r.getString(1)
            val count = r.getInt(2)
            val last_used = r.getDouble(3)
            _pm_id.setString(1, text)
            _pm_id.setString(2, pin_yin)
            _pm_id.setString(3, pinyin)
            _pm_id.setInt(4, count)
            _pm_id.setDouble(5, last_used)
            _pm_id.executeUpdate()
        }
        return true
    }

    fun get_char_freq(pinyin: String): CoreUserList? {
        // query cache first
        _pm_sf_c.setString(1, pinyin)
        var r = _pm_sf_c.executeQuery()  // order by count
        if (! r.isBeforeFirst()) {
            // no data in cache, try load data first
            if (! _load_data_freq(pinyin)) {
                return null  // no data to load
            }
            // query cache again
            r = _pm_sf_c.executeQuery()
        }
        val o_c: MutableList<TextCount> = mutableListOf()
        while (r.next()) {
            val char = r.getString(1)
            val count = r.getInt(2)
            o_c.add(TextCount(char, count))
        }
        // qurey cache order by last_used
        _pm_sf_l.setString(1, pinyin)
        r = _pm_sf_l.executeQuery()
        val o_l: MutableList<TextValue> = mutableListOf()
        while (r.next()) {
            val char = r.getString(1)
            val last_used = r.getDouble(2)
            o_l.add(TextValue(char, last_used))
        }
        return CoreUserList(o_c, o_l)
    }

    fun get_dict(pinyin: List<String>): CoreUserList? {
        val pin_yin = _join_pin_yin(pinyin)
        val join_pinyin = _join_pinyin(pinyin)
        // query cache first
        _pm_sd_c.setString(1, pin_yin)
        var r = _pm_sd_c.executeQuery()
        if (! r.isBeforeFirst()) {
            // no data in cache, try load data first
            if (! _load_data_dict(pin_yin, join_pinyin)) {
                return null  // no data to load
            }
            // query cache again
            r = _pm_sd_c.executeQuery()
        }
        val o_c: MutableList<TextCount> = mutableListOf()
        while (r.next()) {
            val text = r.getString(1)
            val count = r.getInt(2)
            o_c.add(TextCount(text, count))
        }
        // query cache order by last_used
        _pm_sd_l.setString(1, pin_yin)
        r = _pm_sd_l.executeQuery()
        val o_l: MutableList<TextValue> = mutableListOf()
        while (r.next()) {
            val text = r.getString(1)
            val last_used = r.getDouble(2)
            o_l.add(TextValue(text, last_used))
        }
        return CoreUserList(o_c, o_l)
    }

    // TODO support user_dict with pinyin (merged pinyin, not pin_yin) ?

    // record user input
    fun on_input(text: String, pin_yin: String) {
        val pinyin = _split_pin_yin(pin_yin)
        val join_pinyin = _join_pinyin(pinyin)
        val last_used = get_julian_time_now()
        // update user_dict new changes, try update before insert
        _pn_ud.setInt(1, 1)  // count += 1
        _pn_ud.setDouble(2, last_used)
        _pn_ud.setString(3, text)
        _pn_ud.setString(4, pin_yin)
        var r = _pn_ud.executeUpdate()
        if (r < 1) {  // INSERT it
            _pn_id.setString(1, text)
            _pn_id.setString(2, pin_yin)
            _pn_id.setString(3, join_pinyin)
            _pn_id.setInt(4, 1)  // count = 1
            _pn_id.setDouble(5, last_used)
            _pn_id.executeUpdate()
        }
        // update user_dict cache, try update before insert
        _pm_ud.setInt(1, 1)  // count += 1
        _pm_ud.setDouble(2, last_used)
        _pm_ud.setString(3, text)
        _pm_ud.setString(4, pin_yin)
        r = _pm_ud.executeUpdate()
        if (r < 1) {  // INSERT it
            _pm_id.setString(1, text)
            _pm_id.setString(2, pin_yin)
            _pm_id.setString(3, join_pinyin)
            _pm_id.setInt(4, 1)  // count = 1
            _pm_id.setDouble(5, last_used)
            _pm_id.executeUpdate()
        }

        // update user_freq, for each char-pinyin pair
        // assert: text.length == pinyin.length
        for (i in 0 until text.length) {
            val char = text[i].toString()
            val pin = pinyin[i]
            // update new changes, try update before insert
            _pn_uf.setInt(1, 1)  // count += 1
            _pn_uf.setDouble(2, last_used)
            _pn_uf.setString(3, char)
            _pn_uf.setString(4, pin)
            r = _pn_uf.executeUpdate()
            if (r < 1) {  // INSERT it
                _pn_if.setString(1, char)
                _pn_if.setString(2, pin)
                _pn_if.setInt(3, 1)  // count = 1
                _pn_if.setDouble(4, last_used)
                _pn_if.executeUpdate()
            }
            // update cache, try update before insert
            _pm_uf.setInt(1, 1)  // count += 1
            _pm_uf.setDouble(2, last_used)
            _pm_uf.setString(3, char)
            _pm_uf.setString(4, pin)
            r = _pm_uf.executeUpdate()
            if (r < 1) {  // INSERT it
                _pm_if.setString(1, char)
                _pm_if.setString(2, pin)
                _pm_if.setInt(3, 1)  // count = 1
                _pm_if.setDouble(4, last_used)
                _pm_if.executeUpdate()
            }
        }
    }

    // save changes in database
    fun commit_changes() {
        // begin transaction
        _c.autoCommit = false

        // new changes for user_dict
        var r = _pn_sd.executeQuery()
        while (r.next()) {
            val text = r.getString(1)
            val pin_yin = r.getString(2)
            val pinyin = r.getString(3)
            val count = r.getInt(4)
            val last_used = r.getDouble(5)
            // try update first
            _p_ud.setInt(1, count)
            _p_ud.setDouble(2, last_used)
            _p_ud.setString(3, text)
            _p_ud.setString(4, pin_yin)
            val i = _p_ud.executeUpdate()
            if (i < 1) {  // INSERT it
                _p_id.setString(1, text)
                _p_id.setString(2, pin_yin)
                _p_id.setString(3, pinyin)
                _p_id.setInt(4, count)
                _p_id.setDouble(5, last_used)
                _p_id.executeUpdate()
            }
        }
        // new changes for user_freq
        r = _pn_sf.executeQuery()
        while (r.next()) {
            val char = r.getString(1)
            val pinyin = r.getString(2)
            val count = r.getInt(3)
            val last_used = r.getDouble(4)
            // try update first
            _p_uf.setInt(1, count)
            _p_uf.setDouble(2, last_used)
            _p_uf.setString(3, char)
            _p_uf.setString(4, pinyin)
            val i = _p_uf.executeUpdate()
            if (i < 1) {  // INSERT it
                _p_if.setString(1, char)
                _p_if.setString(2, pinyin)
                _p_if.setInt(3, count)
                _p_if.setDouble(4, last_used)
                _p_if.executeUpdate()
            }
        }

        // TODO error process ?
        // commit
        _c.commit()
        _c.autoCommit = true

        _reset_new_changes()
    }
}

// core_user result list: c: sort by count; u: sort by last_used
data class CoreUserList(val c: List<TextCount>, val u: List<TextValue>)
