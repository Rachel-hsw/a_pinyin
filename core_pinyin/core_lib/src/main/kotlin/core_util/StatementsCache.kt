package org.sceext.a_pinyin.core_util

import java.sql.Connection
import java.sql.PreparedStatement


// prepare SQL statement, and cache it
class StatementsCache(val conn: Connection) {

    private var _c: MutableMap<String, PreparedStatement> = mutableMapOf()

    fun clear() {
        _c = mutableMapOf()
    }

    private fun _create_statement(s: String) {
        // FIXME DEBUG log here
        println("DEBUG: StatementsCache  create statement:  ${s}")

        _c[s] = conn.prepareStatement(s)
    }

    // get one statement, and prepare (create) it if needed
    fun s(statement: String): PreparedStatement {
        if (! _c.contains(statement)) {
            _create_statement(statement)
        }
        return _c[statement]!!
    }
}
