package org.sceext.a_pinyin.tool_lib

import java.io.File
import java.nio.file.Path

import com.beust.klaxon.Parser
import com.beust.klaxon.JsonObject


fun parse_json(text: String): JsonObject {
    val b = StringBuilder(text)
    val parser = Parser()
    return parser.parse(b) as JsonObject
}

fun read_text_file(filename: String): String {
    val f = File(filename)
    return f.readText()
}

fun save_json_file(filename: String, data: JsonObject) {
    val text = data.toJsonString() + "\n"
    write_replace(filename, text)
}

const val TMP_SUFFIX: String = ".tmp"

fun write_replace(filename: String, text: String, suffix: String = TMP_SUFFIX) {
    val tmp_file = File(filename + suffix)
    tmp_file.writeText(text)  // write
    tmp_file.renameTo(File(filename))  // replace
}

// ensure parent dir exists
fun check_parent_dir(filename: String) {
    val parent = File(filename).parentFile
    if (! parent.exists()) {
        parent.mkdirs()
    }
}

fun get_sub_path(raw: String, host: String): String {
    val r = File(raw).absoluteFile.toPath().normalize()
    val h = File(host).absoluteFile.toPath().normalize()

    val o = h.relativize(r)
    return o.toString()
}

fun concat_path(a: String, b: String): String {
    return File(File(a), b).path
}
