package org.sceext.a_pinyin.tool_hmm_args

import java.io.File

import com.beust.klaxon.JsonObject

import org.sceext.a_pinyin.tool_lib.parse_json
import org.sceext.a_pinyin.tool_lib.read_text_file
import org.sceext.a_pinyin.tool_lib.save_json_file


fun _feed_one_file(eater: Eater, text: String) {
    for (c in text) {
        eater.feed_char(c)
    }
    eater.feed_end()
}

// command line: tool.jar char_sort.json LIST_FILE RESULT_FILE
fun main(args: Array<String>) {
    val f_char_sort = args[0]
    val f_list = args[1]
    val f_result = args[2]

    // create eater
    val eater = Eater()
    // load char_sort.json
    println("DEBUG: load ${f_char_sort}")
    val char_sort = parse_json(read_text_file(f_char_sort))

    eater.load_char_sort(char_sort)

    // load file list
    println("DEBUG: load list ${f_list}")
    val raw = read_text_file(f_list)
    val l = raw.lines()
    var i = 0
    // load each file
    for (f in l) {
        i += 1
        if (f.trim().length < 1) {
            println(" skip empty ${i}  ${f}")
            continue
        }
        println(" ${i} / ${l.size}  load ${f}")
        val one = File(File(f_list).getParentFile(), f)
        val text = read_text_file(one.path)

        _feed_one_file(eater, text)
    }

    val result = eater.export()
    save_json_file(f_result, result)
}
