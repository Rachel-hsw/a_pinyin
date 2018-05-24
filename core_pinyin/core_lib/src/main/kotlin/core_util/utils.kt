package org.sceext.a_pinyin.core_util

import java.sql.Connection
import java.sql.DriverManager


data class TextCount(val text: String, val count: Int)

data class TextValue(val text: String, val value: Double)


fun <T> MutableList<T>.copy(): MutableList<T> {
    val o: MutableList<T> = mutableListOf()
    o.addAll(this)

    return o
}

// create an in-memory sqlite3 database
fun make_inmemory_db(): Connection {
    val conn = DriverManager.getConnection("jdbc:sqlite::memory:")
    return conn
}


open class CoreException: Exception {
    constructor(m: String): super(m)
    constructor(m: String, c: Throwable): super(m, c)
}

class BadDataFileException: CoreException {
    constructor(m: String): super(m)
    constructor(m: String, c: Throwable): super(m, c)
}

class BadConfigException: CoreException {
    constructor(m: String): super(m)
    constructor(m: String, c: Throwable): super(m, c)
}

class UnknowPinyinException: CoreException {
    constructor(m: String): super(m)
    constructor(m: String, c: Throwable): super(m, c)
}
