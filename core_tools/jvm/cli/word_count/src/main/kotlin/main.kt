package org.sceext.a_pinyin.tool_word_count

import java.io.File
import java.sql.Connection
import java.sql.DriverManager

import org.sceext.a_pinyin.tool_lib.read_text_file


// command line: tool.jar LIST_FILE db_file.db
fun main(args: Array<String>) {
    val f_list = args[0]
    val f_db = args[1]

    // load file list
    println("DEBUG: load list ${f_list}")
    val raw = read_text_file(f_list)
    val l = raw.lines()

    // open database file
    println("DEBUG: open database ${f_db}")
    val conn = DriverManager.getConnection("jdbc:sqlite:${f_db}")
    // FIXME transactions here
    conn.autoCommit = false

    // create eater
    val eater = Eater()

    var i = 0
    // load each file
    for (f in l) {
        i += 1
        if (f.trim().length < 1) {
            println(" skip empty ${i}  ${f}")
            continue
        }
        val one = File(File(f_list).getParentFile(), f)

        println(" ${i} / ${l.size}  load ${f}")
        val text = read_text_file(one.path)
        // feed one file
        eater.feed(text, conn)
    }
    // FIXME add transactions here
    println("DEBUG: COMMIT")
    conn.commit()

    // more operations on database
    val s = conn.createStatement()
    conn.autoCommit = true

    println("DEBUG: ANALYZE")
    s.executeUpdate("ANALYZE")

    println("DEBUG: VACUUM")
    s.executeUpdate("VACUUM")

    // done
    conn.close()
}
