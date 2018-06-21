package org.sceext.a_pinyin.post

import org.sceext.a_pinyin.ApinyinInterface


const val A_PINYIN_INTERFACE_VERSION: String = "0.1.0"

class PostBinder : ApinyinInterface.Stub() {

    override fun version(): String {
        return A_PINYIN_INTERFACE_VERSION
    }

    private fun _get_package_name(): String {
        // TODO
        return "TODO"
    }

    override fun request_permission(): Boolean {
        // TODO
        return false
    }

    override fun post(json: String): Boolean {
        // TODO
        return false
    }
}
