package org.sceext.a_pinyin.core

import java.sql.Connection
import java.sql.PreparedStatement


// data_user_symbol2 export function
// TODO error process ?

// list all user added symbol2 items
fun dus2_list(): List<String> {
    // open databases
    val core = open_db_core()
    val user = open_db_user()
    // get all core symbol2 items
    val s_core = core.prepareStatement("SELECT text FROM a_pinyin_symbol2")
    val s: MutableSet<String> = mutableSetOf()
    var r = s_core.executeQuery()
    while (r.next()) {
        val text = r.getString(1)
        s.add(text)
    }
    // load all user symbol2, not in core db
    val s_user = user.prepareStatement("SELECT text FROM a_pinyin_user_symbol2 ORDER BY last_used DESC, count DESC, text")
    val o: MutableList<String> = mutableListOf()
    r = s_user.executeQuery()
    while (r.next()) {
        val text = r.getString(1)
        if (! s.contains(text)) {
            o.add(text)
        }
    }
    // close database
    core.close()
    user.close()

    return o
}

// add one user symbol2 item
fun dus2_add(text: String) {
    val conn = open_db_user()
    try {
        val s = conn.prepareStatement("INSERT INTO a_pinyin_user_symbol2(text, count, last_used) VALUES (?, ?, ?)")
        s.setString(1, text)
        s.setInt(2, 0)
        s.setDouble(3, 0.0)
        s.executeUpdate()

        conn.autoCommit = true
    } finally {
        conn.close()
    }
}

// remove one user symbol2 item
fun dus2_rm(items: List<String>) {
    val conn = open_db_user()
    try {
        val s = conn.prepareStatement("DELETE FROM a_pinyin_user_symbol2 WHERE text = ?")
        // begin transaction
        conn.autoCommit = false
        for (i in items) {
            s.setString(1, i)
            s.executeUpdate()
        }
        // commit
        conn.autoCommit = true
    } finally {
        conn.close()
    }
}
