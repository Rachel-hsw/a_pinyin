package org.sceext.a_pinyin.tool_pinyin_cut_mm

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

// command line: tool.jar char_to_pinyin.json pinyin_freq.json LIST_FILE RESULT_FILE
fun main(args: Array<String>) {
    val f_char_to_pinyin = args[0]
    val f_pinyin_freq = args[1]
    val f_list = args[2]
    val f_result = args[3]

    // create eater
    val eater = Eater()
    // load data
    println("DEBUG: load ${f_char_to_pinyin}")
    val char_to_pinyin = parse_json(read_text_file(f_char_to_pinyin))
    println("DEBUG: load ${f_pinyin_freq}")
    val pinyin_freq = parse_json(read_text_file(f_pinyin_freq))

    eater.load_char_to_pinyin(char_to_pinyin)
    eater.load_pinyin_freq(pinyin_freq)

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
