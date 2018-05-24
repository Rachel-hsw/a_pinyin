package org.sceext.a_pinyin.cli_lib

import java.io.File

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
