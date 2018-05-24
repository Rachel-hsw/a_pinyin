package org.sceext.a_pinyin.tool_word_seg

import java.io.File

import com.beust.klaxon.JsonObject

import org.sceext.a_pinyin.tool_lib.parse_json
import org.sceext.a_pinyin.tool_lib.read_text_file
import org.sceext.a_pinyin.tool_lib.write_replace
import org.sceext.a_pinyin.tool_lib.check_parent_dir
import org.sceext.a_pinyin.tool_lib.get_sub_path
import org.sceext.a_pinyin.tool_lib.concat_path


// command line: tool.jar char_sort.json LIST_FILE SRC_DIR RESULT_DIR
fun main(args: Array<String>) {
    val f_char_sort = args[0]
    val f_list = args[1]
    val d_src = args[2]
    val d_result = args[3]

    // create eater
    val eater = Eater()
    // load data
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

        val one = File(File(f_list).getParentFile(), f)
        // check skip file
        val sub_path = get_sub_path(one.path, d_src)
        val f_result = concat_path(d_result, sub_path)
        if (File(f_result).exists()) {
            println(" ${i} / ${l.size}  SKIP ${one} -> ${f_result}")
            continue
        }

        println(" ${i} / ${l.size}  load ${f}")
        val text = read_text_file(one.path)

        // feed one file
        val result = eater.feed(text)
        // save result
        println("    -> ${f_result}")

        check_parent_dir(f_result)
        write_replace(f_result, result)
    }
}
