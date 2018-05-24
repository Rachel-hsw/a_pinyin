package org.sceext.a_pinyin.core

import java.sql.Connection

import com.esotericsoftware.kryo.Kryo
import com.esotericsoftware.kryo.io.Input

import org.sceext.a_pinyin.core_util.CoreException
import org.sceext.a_pinyin.core_util.UnknowPinyinException
import org.sceext.a_pinyin.core_pinyin_cut.ACorePinyinCut
import org.sceext.a_pinyin.core_pinyin_cut.ACorePinyinCutData
import org.sceext.a_pinyin.core_pinyin_cut.PinyinCutResult
import org.sceext.a_pinyin.core_freq.MAX_LEVEL
import org.sceext.a_pinyin.core_freq.ACoreFreq
import org.sceext.a_pinyin.core_freq.ACoreFreqData
import org.sceext.a_pinyin.core_hmm.ACoreHmm
import org.sceext.a_pinyin.core_hmm.ACoreHmmData
import org.sceext.a_pinyin.core_hmm.TooFewPinyinException
import org.sceext.a_pinyin.core_dict.ACoreDict
import org.sceext.a_pinyin.core_dict.ACoreDictData
import org.sceext.a_pinyin.core_mix.ACoreMix
import org.sceext.a_pinyin.core_user.BCoreUser


// TODO handle core Exception ?
class CorePinyin {

    lateinit private var _pinyin_cut: ACorePinyinCut
    lateinit private var _core_mix: ACoreMix
    // core_user
    lateinit private var _core_user: BCoreUser

    // nolog mode
    private var _nolog: Boolean = true

    // TODO support core config
    // config core

    fun set_nolog(nolog: Boolean) {
        _nolog = nolog
    }

    // set level of core_mix
    fun set_level(level: Int) {
        _core_mix.set_level(level)
    }

    fun get_level(): Int = _core_mix.get_level()

    fun init(conn: Connection, conn_user: Connection) {
        // TODO better logs ?
        // DEBUG
        println("DEBUG: CorePinyin.init()  start init")

        // load core data and create cores
        _load_data(conn, conn_user)

        // TODO
        println("DEBUG: CorePinyin.init()  done")
    }

    private fun _load_data(conn: Connection, conn_user: Connection) {
        // load core kryo data
        val p = conn.prepareStatement("SELECT kryo FROM a_pinyin_core_data WHERE name = ?")
        val kryo = Kryo()

        println("DEBUG: load kryo pinyin_cut")
        p.setString(1, "pinyin_cut")
        var r = p.executeQuery()
        r.next()
        var blob = r.getBytes(1)

        var i = Input(blob.inputStream())
        val pinyin_cut_data = kryo.readObject(i, ACorePinyinCutData::class.java)
        i.close()

        println("DEBUG: load kryo core_freq")
        p.setString(1, "core_freq")
        r = p.executeQuery()
        r.next()
        blob = r.getBytes(1)

        i = Input(blob.inputStream())
        val core_freq_data = kryo.readObject(i, ACoreFreqData::class.java)
        i.close()

        println("DEBUG: load kryo core_hmm")
        p.setString(1, "core_hmm")
        r = p.executeQuery()
        r.next()
        blob = r.getBytes(1)

        i = Input(blob.inputStream())
        val core_hmm_data = kryo.readObject(i, ACoreHmmData::class.java)
        i.close()

        println("DEBUG: load kryo core_dict")
        p.setString(1, "core_dict")
        r = p.executeQuery()
        r.next()
        blob = r.getBytes(1)

        i = Input(blob.inputStream())
        val core_dict_data = kryo.readObject(i, ACoreDictData::class.java)
        i.close()

        // create sub cores and load data
        println("DEBUG: core.load_data()")

        val pinyin_cut = ACorePinyinCut()
        pinyin_cut.load_data(pinyin_cut_data)
        _pinyin_cut = pinyin_cut

        val core_freq = ACoreFreq()
        core_freq.load_data(core_freq_data)

        val core_hmm = ACoreHmm()
        core_hmm.load_data(core_hmm_data)

        val core_dict = ACoreDict()
        core_dict.load_data(core_dict_data)

        // SET Connection
        println("DEBUG: core_dict.set_connection(conn)")
        core_dict.set_connection(conn)

        // create core_user
        val core_user = BCoreUser()
        println("DEBUG: core_user.set_connection(conn_user)")
        core_user.set_connection(conn_user)
        _core_user = core_user

        // create mix core
        println("DEBUG: create mix core")
        val core_mix = ACoreMix(core_freq, core_hmm, core_dict, core_user)
        _core_mix = core_mix
    }

    fun on_destroy() {
        // TODO
    }

    // for core_user
    fun on_input(text: String, pin_yin: String) {
        // not check nolog again
        _core_user.on_input(text, pin_yin)
    }

    fun commit_changes() {
        _core_user.commit_changes()
    }

    // export function
    fun pinyin_cut(raw: String): List<PinyinCutResult> {
        return _pinyin_cut.cut(raw)
    }

    // export function
    fun get_text(pinyin: List<String>): List<List<String>> {
        // process core Exception
        try {
            return _core_mix.get_text(pinyin)
        } catch (e: Exception) {
            // not log in nolog mode
            if (! _nolog) {
                e.printStackTrace()
            }
            // ignore error
            return listOf()
        }
    }
}
