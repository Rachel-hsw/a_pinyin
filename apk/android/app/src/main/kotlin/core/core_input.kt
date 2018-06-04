package org.sceext.a_pinyin.core

import java.sql.Connection
import java.sql.DriverManager

import com.beust.klaxon.json
import com.beust.klaxon.JsonObject
import com.beust.klaxon.JsonArray

import org.sceext.a_pinyin.core_symbol.BCoreSymbol
import org.sceext.a_pinyin.core_symbol.BCoreSymbol2
import org.sceext.a_pinyin.send_native_event


const val INPUT_MODE_OTHER: Int = 0
const val INPUT_MODE_SYMBOL: Int = 1
const val INPUT_MODE_SYMBOL2: Int = 2
const val INPUT_MODE_PINYIN: Int = 3

// sqlite3 database file
const val CORE_DATA_DB: String = "/sdcard/a_pinyin/core/core_data.db"
const val USER_DATA_DB: String = "/sdcard/a_pinyin/user/user_data.db"

const val CORE_DATA_DB_NAME: String = "core_data.db"
const val USER_DATA_DB_NAME: String = "user_data.db"

// sqlite3: ANALYZE and VACUUM
fun clean_user_db() {
    val conn = _open_db_user(USER_DATA_DB)
    // turn-off transaction
    conn.autoCommit = true

    println("DEBUG: core_input.clean_user_db()  ANALYZE")
    // ANALYZE
    conn.prepareStatement("ANALYZE").execute()

    println("DEBUG: core_input.clean_user_db()  VACUUM")
    // VACUUM
    conn.prepareStatement("VACUUM").execute()

    // close connection
    conn.close()
    println("DEBUG: core_input.clean_user_db()  [ OK ]")
}

fun get_db_info(): JsonObject {
    var core_db_info: JsonArray<Any?>? = null
    var user_db_info: JsonArray<Any?>? = null
    var conn: Connection? = null
    var conn_user: Connection? = null
    try {
        conn = _open_db(CORE_DATA_DB)
        core_db_info = _get_one_db_info(conn)
    } catch (e: Exception) {
        e.printStackTrace()  // ignore error
    }
    try {
        conn_user = _open_db_user(USER_DATA_DB)
        user_db_info = _get_one_db_info(conn_user)
    } catch (e: Exception) {
        e.printStackTrace()  // ignore error
    }
    // close connection
    conn?.close()
    conn_user?.close()

    return json {
        obj(CORE_DATA_DB_NAME to core_db_info,
            USER_DATA_DB_NAME to user_db_info)
    }
}

private fun _get_one_db_info(conn: Connection): JsonArray<Any?> {
    val p = conn.prepareStatement("SELECT name, value, `desc` FROM a_pinyin")
    val r = p.executeQuery()

    val o: MutableList<JsonObject> = mutableListOf()
    while (r.next()) {
        val one = json {
            obj("name" to r.getString(1),
                "value" to r.getString(2),
                "desc" to r.getString(3))
        }
        o.add(one)
    }
    return json {
        array(o)
    }
}

private fun _open_db(db_file: String): Connection {
    println("DEBUG: core_input: open sqlite3 database  ${db_file}")
    // load jdbc driver first
    Class.forName("org.sqlite.JDBC")

    val conn = DriverManager.getConnection("jdbc:sqlite:${db_file}")

    return conn
}

private fun _open_db_user(db_file: String): Connection {
    println("DEBUG: core_input: open user database  ${db_file}")

    val conn = DriverManager.getConnection("jdbc:sqlite:${db_file}")
    return conn
}


class CoreInput {

    private var _pinyin: CorePinyin? = null
    private var _symbol: BCoreSymbol? = null
    private var _symbol2: BCoreSymbol2? = null

    private var _conn: Connection? = null  // core_data.db
    private var _conn_user: Connection? = null  // user_data.db

    // nolog mode
    private var _nolog: Boolean = true  // default log nothing

    // export var
    fun pinyin(): CorePinyin = _pinyin!!
    fun symbol(): BCoreSymbol = _symbol!!
    fun symbol2(): BCoreSymbol2 = _symbol2!!


    // TODO improve lifecycle callbacks handle

    // `true` between `on_start_input()` and `on_end_input()`
    private var _is_input: Boolean = false
    private var _input_mode: Int = 0  // TODO

    private var _is_init_done: Boolean = false


    fun init() {
        // TODO better logs ?
        // DEBUG
        println("DEBUG: CoreInput.init()  start init")

        // TODO handle init Exception ?

        // open databases first
        val conn = _open_db(CORE_DATA_DB)
        _conn = conn
        val conn_user = _open_db_user(USER_DATA_DB)
        _conn_user = conn_user
        // TODO check database (a_pinyin data format) version ?

        // init core_symbol
        val core_symbol = BCoreSymbol()
        println("DEBUG: core_symbol.set_connection(conn_user)")
        core_symbol.set_connection(conn_user)
        _symbol = core_symbol

        // init core_symbol2
        val core_symbol2 = BCoreSymbol2()
        println("DEBUG: core_symbol2.set_connection(conn, conn_user)")
        core_symbol2.set_connection(conn, conn_user)
        _symbol2 = core_symbol2

        // create and init CorePinyin
        val core_pinyin = CorePinyin()
        core_pinyin.init(conn, conn_user)
        _pinyin = core_pinyin

        println("DEBUG: CoreInput.init()  config core")
        // init nolog
        core_pinyin.set_nolog(_nolog)
        // default level: C
        core_pinyin.set_level(2)

        println("DEBUG: CoreInput.init()  done")
        _is_init_done = true
    }

    // FIXME start_input / end_input is still very BUG

    // lifecycle callback, used for reset core state, etc.
    // TODO support start input mode
    // TODO support password mode (no any record) ?
    fun on_start_input(mode: Int = 0) {
        println("DEBUG: CoreInput.on_start_input()")
        // TODO

        _input_mode = mode
        _is_input = true

        // emit event
        val event = json {
            obj("type" to "core_start_input",
                "payload" to obj("mode" to mode)
                )
        }
        send_native_event(event)
    }

    // nolog mode
    fun get_nolog(): Boolean = _nolog

    fun set_nolog(nolog: Boolean) {
        _nolog = nolog
        // pass nolog to core_pinyin
        _pinyin?.set_nolog(_nolog)

        // emit event
        val event = json {
            obj("type" to "core_nolog_mode_change")
        }
        send_native_event(event)
    }

    // for log user input
    fun on_input(text: String? = null, mode: Int = 0, pin_yin: String? = null) {
        // check nolog mode
        if (_nolog) {
            return
        }
        // check input mode
        when (mode) {
            INPUT_MODE_SYMBOL -> {
                // check text
                if (text == null) {
                    return  // just ignore
                }
                _symbol?.on_input(text)
            }
            INPUT_MODE_SYMBOL2 -> {
                // check text
                if (text == null) {
                    return
                }
                _symbol2?.on_input(text)
            }
            INPUT_MODE_PINYIN -> {
                if (text == null) {
                    return
                }
                // check pin_yin
                if (pin_yin == null) {
                    return
                }
                _pinyin?.on_input(text, pin_yin)
            }
            else -> {
                // just ignore
            }
        }
    }

    fun on_end_input() {
        println("DEBUG: CoreInput.on_end_input()")
        // TODO

        // save user input (log) changes
        _symbol?.commit_changes()
        _symbol2?.commit_changes()
        _pinyin?.commit_changes()

        _is_input = false

        // emit event
        val event = json {
            obj("type" to "core_end_input")
        }
        send_native_event(event)
    }

    // NOTE: this may not be called before process exit
    fun on_destroy() {
        println("DEBUG: CoreInput.on_destroy()")
        // TODO

        _pinyin?.on_destroy()

        // close database connection
        _conn?.close()
        _conn_user?.close()
    }
}
