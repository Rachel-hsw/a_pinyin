package org.sceext.a_pinyin.core_mix

import java.sql.Connection
import java.sql.DriverManager

import com.esotericsoftware.kryo.Kryo
import com.esotericsoftware.kryo.io.Output
import com.esotericsoftware.kryo.io.Input

import org.sceext.a_pinyin.core_freq.ACoreFreq
import org.sceext.a_pinyin.core_freq.ACoreFreqData
import org.sceext.a_pinyin.core_hmm.ACoreHmm
import org.sceext.a_pinyin.core_hmm.ACoreHmmData
import org.sceext.a_pinyin.core_dict.ACoreDict
import org.sceext.a_pinyin.core_dict.ACoreDictData


fun _print_help() {
    val text = """
    | Avaliable commands:
    |     .exit    Exit command loop
    |     .help    Show this help text
    |     .config  Show current core config
    |     .level   Set char level
    """.trimMargin()
    println(text)
}

fun _show_config(core: ACoreMix) {
    println("Current config:")
    val level = when(core.get_level()) {
        0 -> "A"
        1 -> "B"
        2 -> "C"
        3 -> "D"
        4 -> "E"
        else -> core.get_level()
    }
    println("    level = ${level}")
}

fun _set_level(core: ACoreMix, command: String) {
    // eg: .level a
    if (command.length < 8) {
        println("ERROR: unknow level. ([A|B|C|D|E])")
        return
    }
    val level = when(command[7]) {
        'a', 'A' -> 0
        'b', 'B' -> 1
        'c', 'C' -> 2
        'd', 'D' -> 3
        'e', 'E' -> 4
        else -> {
            println("ERROR: unknow level ${command[7]}. ([A|B|C|D|E])")
            return
        }
    }
    core.set_level(level)
}

fun _one_command(core: ACoreMix, command: String) {
    when(command) {
        // .exit
        ".help" -> _print_help()
        ".config" -> _show_config(core)
        else -> {
            // .level
            if (command.startsWith(".level")) {
                _set_level(core, command)
            } else {
                println("ERROR: unknow command. Please try `.help`")
            }
        }
    }
}

fun _one_pinyin(core: ACoreMix, pinyin: String) {
    try {
        // cut pinyin
        val raw = pinyin.trim().split(" ")
        // TODO clean each pinyin ?

        val r = core.get_text(raw)
        // print result
        var i = 1
        for (j in r) {
            for (k in j) {
                println("${i}\t${k}")
                i += 1
            }
            println()
        }
    } catch (e: Exception) {
        println("ERROR: unknow core exception")
        e.printStackTrace()
    }
}


const val PROMPT: String = "core_mix> "

fun _main_loop(core: ACoreMix) {
    while (true) {
        print(PROMPT)
        val one = readLine()
        if (one == null) {
            break  // just exit command loop
        }
        // empty input
        if (one.trim() == "") {
            continue
        }
        // check for command
        if (one.startsWith(".")) {
            if (one == ".exit") {
                break
            }
            _one_command(core, one)
        } else {  // normal pinyin
            _one_pinyin(core, one)
        }
    }
}


// create and init the core
fun _init_core(conn: Connection): ACoreMix {
    // load core kryo data
    val p = conn.prepareStatement("SELECT kryo FROM a_pinyin_core_data WHERE name = ?")
    val kryo = Kryo()

    println("DEBUG: load kryo core_freq")
    p.setString(1, "core_freq")
    var r = p.executeQuery()
    r.next()
    var blob = r.getBytes(1)

    var i = Input(blob.inputStream())
    val core_freq_data = kryo.readObject(i, ACoreFreqData::class.java)
    i.close()

    println("DEBUG: load kryo core_hmm")
    p.setString(1, "core_hmm")
    r = p.executeQuery()
    r.next()
    blob = r.getBytes(1)

    i = Input(blob.inputStream())
    val core_hmm_data = kryo.readObject(i, ACoreHmmData::class.java)
    i.close()

    println("DEBUG: load kryo core_dict")
    p.setString(1, "core_dict")
    r = p.executeQuery()
    r.next()
    blob = r.getBytes(1)

    i = Input(blob.inputStream())
    val core_dict_data = kryo.readObject(i, ACoreDictData::class.java)
    i.close()

    // create sub cores and load data
    println("DEBUG: core.load_data()")
    val core_freq = ACoreFreq()
    core_freq.load_data(core_freq_data)
    val core_hmm = ACoreHmm()
    core_hmm.load_data(core_hmm_data)
    val core_dict = ACoreDict()
    core_dict.load_data(core_dict_data)

    core_dict.set_connection(conn)

    // create mix core
    println("DEBUG: creata mix core")
    val core = ACoreMix(core_freq, core_hmm, core_dict)
    return core
}

fun main(args: Array<String>) {
    val db_file = args[0]

    println("DEBUG: open sqlite3 database ${db_file}")
    val conn = DriverManager.getConnection("jdbc:sqlite:${db_file}")

    val core = _init_core(conn)
    // config core
    core.set_level(2)  // default level: C

    // core init done, enter CLI
    _main_loop(core)

    conn.close()
}
