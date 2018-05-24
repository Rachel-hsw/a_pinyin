package org.sceext.a_pinyin.core_pinyin_cut

import java.io.FileInputStream
import java.io.FileOutputStream

import com.beust.klaxon.JsonObject

import com.esotericsoftware.kryo.Kryo
import com.esotericsoftware.kryo.io.Output
import com.esotericsoftware.kryo.io.Input

import org.sceext.a_pinyin.cli_lib.parse_json
import org.sceext.a_pinyin.cli_lib.read_text_file


fun _print_help() {
    val text = """
    | Avaliable commands:
    |     .exit    Exit command loop
    |     .help    Show this help text
    """.trimMargin()
    println(text)
}

fun _one_command(core: ACorePinyinCut, command: String) {
    when(command) {
        // .exit
        ".help" -> _print_help()
        else -> {
            println("ERROR: unknow command. Please try `.help`")
        }
    }
}

// do one pinyin cut
fun _one_raw(core: ACorePinyinCut, raw: String) {
    val result = core.cut(raw.trim())

    for (r in result) {
        println(" + " + _print_result(r))
    }
}

fun _print_result(r: PinyinCutResult): String {
    var o = "${r.pinyin.joinToString("'")}"
    if (r.rest != null) {
        o += ", ${r.rest}"
    }
    o += "\t${r.sort_value}"
    return o
}


const val PROMPT: String = "core_pinyin_cut> "

fun _main_loop(core: ACorePinyinCut) {
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
fun _load_data_json(filename: String): ACorePinyinCutData {
    println("DEBUG: start load json data ${filename}")
    val text = read_text_file(filename)

    println("DEBUG: parse json")
    val data = parse_json(text)

    println("DEBUG: core_data.load_json()")
    val core_data = ACorePinyinCutData()
    core_data.load_json(data)

    return core_data
}

fun _export_data_kryo(filename: String, data: ACorePinyinCutData) {
    println("DEBUG: export kryo data to ${filename}")

    val kryo = Kryo()
    val o = Output(FileOutputStream(filename))
    kryo.writeObject(o, data)
    o.close()
}

fun _load_data_kryo(filename: String): ACorePinyinCutData {
    println("DEBUG: load kryo data ${filename}")

    val kryo = Kryo()
    val i = Input(FileInputStream(filename))
    val o = kryo.readObject(i, ACorePinyinCutData::class.java)
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
    val core = ACorePinyinCut()

    println("DEBUG: core.load_data()")
    core.load_data(core_data)

    // core init done, enter CLI
    _main_loop(core)
}
