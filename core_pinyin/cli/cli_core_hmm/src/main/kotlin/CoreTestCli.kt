package org.sceext.a_pinyin.core_hmm

import java.io.FileInputStream
import java.io.FileOutputStream

import com.beust.klaxon.JsonObject

import com.esotericsoftware.kryo.Kryo
import com.esotericsoftware.kryo.io.Output
import com.esotericsoftware.kryo.io.Input

import org.sceext.a_pinyin.core_util.TextValue
import org.sceext.a_pinyin.core_util.CoreException
import org.sceext.a_pinyin.cli_lib.parse_json
import org.sceext.a_pinyin.cli_lib.read_text_file


fun _print_help() {
    val text = """
    | Avaliable commands:
    |     .exit    Exit command loop
    |     .help    Show this help text
    |     .config  Show current core config
    |     .n       Set N for n-best viterbi
    """.trimMargin()
    println(text)
}


// config: for n-best viterbi
private var _core_n: Int = 1  // default: n = 1

fun _show_config() {
    println("Current config:")
    println("    n = ${_core_n}")
}

fun _set_n(command: String) {
    // eg: .n 5
    // TODO check bad number
    // TODO more checks on command
    val n = command.slice(2 until command.length).trim().toInt()
    // TODO check bad n

    _core_n = n
}

fun _one_command(core: ACoreHmm, command: String) {
    when(command) {
        // .exit
        ".help" -> _print_help()
        ".config" -> _show_config()
        else -> {
            // .n
            if (command.startsWith(".n")) {
                _set_n(command)
            } else {
                println("ERROR: unknow command. Please try `.help`")
            }
        }
    }
}


// do one hmm viterbi
fun _one_raw(core: ACoreHmm, raw: String) {
    val pinyin = raw.trim().split(" ")  // TODO clean pinyin ?
    // CoreException
    try {
        val result = core.viterbi(pinyin, _core_n)

        for (r in result) {
            println(" + " + _print_result(r))
        }
    } catch (e: CoreException) {
        println("ERROR: ${e}")
    }
}

fun _print_result(r: TextValue): String {
    return "${r.text}\t${r.value}"
}


const val PROMPT: String = "core_hmm> "

fun _main_loop(core: ACoreHmm) {
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
        } else {  // normal input
            _one_raw(core, one)
        }
    }
}


// init core
fun _load_data_json(filename: String): ACoreHmmData {
    println("DEBUG: start load json data ${filename}")
    val text = read_text_file(filename)

    println("DEBUG: parse json")
    val data = parse_json(text)

    println("DEBUG: core_data.load_json()")
    val core_data = ACoreHmmData()
    core_data.load_json(data)

    return core_data
}

fun _export_data_kryo(filename: String, data: ACoreHmmData) {
    println("DEBUG: export kryo data to ${filename}")

    val kryo = Kryo()
    val o = Output(FileOutputStream(filename))
    kryo.writeObject(o, data)
    o.close()
}

fun _load_data_kryo(filename: String): ACoreHmmData {
    println("DEBUG: load kryo data ${filename}")

    val kryo = Kryo()
    val i = Input(FileInputStream(filename))
    val o = kryo.readObject(i, ACoreHmmData::class.java)
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
    val core = ACoreHmm()

    println("DEBUG: core.load_data()")
    core.load_data(core_data)

    // core init done, enter CLI
    _main_loop(core)
}
