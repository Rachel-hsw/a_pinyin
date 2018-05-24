package org.sceext.a_pinyin.core_freq

import java.io.FileInputStream
import java.io.FileOutputStream

import com.beust.klaxon.JsonObject

import com.esotericsoftware.kryo.Kryo
import com.esotericsoftware.kryo.io.Output
import com.esotericsoftware.kryo.io.Input

import org.sceext.a_pinyin.core_util.TextCount
import org.sceext.a_pinyin.core_util.UnknowPinyinException
import org.sceext.a_pinyin.cli_lib.parse_json
import org.sceext.a_pinyin.cli_lib.read_text_file


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


// config: for set_level function
private var _core_level: Int = 0  // default: level A

fun _show_config() {
    println("Current config:")
    val level = when(_core_level) {
        0 -> "A"
        1 -> "B"
        2 -> "C"
        3 -> "D"
        4 -> "E"
        else -> _core_level
    }
    println("    level = ${level}")
}

fun _set_level(command: String) {
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
    _core_level = level
}

fun _one_command(core: ACoreFreq, command: String) {
    when(command) {
        // .exit
        ".help" -> _print_help()
        ".config" -> _show_config()
        else -> {
            // .level
            if (command.startsWith(".level")) {
                _set_level(command)
            } else {
                println("ERROR: unknow command. Please try `.help`")
            }
        }
    }
}

fun _one_pinyin(core: ACoreFreq, pinyin: String) {
    try {
        val raw = core.get_char(pinyin)
        // check _core_level
        val c: MutableList<List<TextCount>> = mutableListOf()
        for (i in 0.. _core_level) {
            c.add(raw[i])
        }

        // print pinyin
        val marks = "bcde"
        var i = 1
        var j = 0
        for (k in c) {
            // print mark
            if (j > 0) {
                println(marks[j - 1])
            }
            j += 1

            for (n in k) {
                println("[${i}] ${n.text} ${n.count}")
                i += 1
            }
        }
    } catch (e: UnknowPinyinException) {
        println("ERROR: unknow pinyin [${pinyin}]")
    }
}


const val PROMPT: String = "core_freq> "

fun _main_loop(core: ACoreFreq) {
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


// init core
fun _load_data_json(filename: String): ACoreFreqData {
    println("DEBUG: start load json data ${filename}")
    val text = read_text_file(filename)

    println("DEBUG: parse json")
    val data = parse_json(text)

    println("DEBUG: core_data.load_json()")
    val core_data = ACoreFreqData()
    core_data.load_json(data)

    return core_data
}

fun _export_data_kryo(filename: String, data: ACoreFreqData) {
    println("DEBUG: export kryo data to ${filename}")

    val kryo = Kryo()
    val o = Output(FileOutputStream(filename))
    kryo.writeObject(o, data)
    o.close()
}

fun _load_data_kryo(filename: String): ACoreFreqData {
    println("DEBUG: load kryo data ${filename}")

    val kryo = Kryo()
    val i = Input(FileInputStream(filename))
    val o = kryo.readObject(i, ACoreFreqData::class.java)
    i.close()

    return o
}

fun main(args: Array<String>) {
    val data_file = args[0]
    // check export
    if (args.size > 1) {
        val export_file = args[1]
        val core_data = _load_data_json(data_file)

        _export_data_kryo(export_file, core_data)
        return
    }
    // check load kryo
    val core_data = if (data_file.endsWith(".json")) {
        _load_data_json(data_file)
    } else {
        _load_data_kryo(data_file)
    }

    // create core and load data
    val core = ACoreFreq()

    println("DEBUG: core.load_data()")
    core.load_data(core_data)

    // core init done, enter CLI
    _main_loop(core)
}
