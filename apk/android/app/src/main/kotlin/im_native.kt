package org.sceext.a_pinyin

import android.content.Context
import android.content.Intent

import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise

import com.facebook.react.modules.core.DeviceEventManagerModule

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.JavaScriptModule
import com.facebook.react.uimanager.ViewManager

import com.beust.klaxon.json
import com.beust.klaxon.JsonObject
import com.beust.klaxon.JsonArray

import org.sceext.a_pinyin.core_util.CoreException
import org.sceext.a_pinyin.core_pinyin_cut.PinyinCutResult

import org.sceext.a_pinyin.core.INPUT_MODE_OTHER
import org.sceext.a_pinyin.core.INPUT_MODE_SYMBOL
import org.sceext.a_pinyin.core.INPUT_MODE_SYMBOL2
import org.sceext.a_pinyin.core.INPUT_MODE_PINYIN

import org.sceext.a_pinyin.core.clean_user_db
import org.sceext.a_pinyin.core.get_db_info


const val MODULE_NAME: String = "im_native"

const val A_PINYIN_NATIVE_EVENT: String = "a_pinyin_native_event"  // used to send native event

// save ImNative instance here
var im_native: ImNative? = null

class ImNative : ReactContextBaseJavaModule {
    constructor(context: ReactApplicationContext): super(context) {
        im_native = this
    }

    override fun getName(): String = MODULE_NAME

    override fun getConstants(): Map<String, Any> {
        return mapOf(
            "A_PINYIN_NATIVE_EVENT" to A_PINYIN_NATIVE_EVENT,
            "INPUT_MODE_OTHER" to INPUT_MODE_OTHER,
            "INPUT_MODE_SYMBOL" to INPUT_MODE_SYMBOL,
            "INPUT_MODE_SYMBOL2" to INPUT_MODE_SYMBOL2,
            "INPUT_MODE_PINYIN" to INPUT_MODE_PINYIN)
    }

    @ReactMethod
    fun close_window(promise: Promise) {
        pinyin_service?.close_window()
        promise.resolve(null)  // TODO never reject
    }

    @ReactMethod
    fun add_text(text: String, mode: Int = 0, pin_yin: String? = null, promise: Promise) {
        pinyin_service?.add_text(text, mode, pin_yin)
        promise.resolve(null)  // TODO never reject
    }

    @ReactMethod
    fun key_delete(promise: Promise) {
        pinyin_service?.key_delete()
        promise.resolve(null)  // TODO never reject
    }

    @ReactMethod
    fun key_enter(promise: Promise) {
        pinyin_service?.key_enter()
        promise.resolve(null)  // TODO never reject
    }

    @ReactMethod
    fun set_pinyin(pinyin: String?, promise: Promise) {
        pinyin_service?.set_pinyin(pinyin)
        promise.resolve(null)  // TODO never reject
    }


    // export pinyin core functions

    @ReactMethod
    fun core_pinyin_cut(raw: String, promise: Promise) {
        val core = pinyin_service?.core()
        if (core == null) {
            val o = json {
                array(emptyList())
            }
            promise.resolve(o.toJsonString())
            return
        }
        // TODO core Exception ?
        val r = core.pinyin().pinyin_cut(raw)
        // export json
        val o: MutableList<JsonObject> = mutableListOf()
        for (one in r) {
            o.add(json {
                obj("pinyin" to array(one.pinyin),
                    "rest" to one.rest,
                    "sort_value" to one.sort_value)
            })
        }
        val j = json {
            array(o)
        }
        promise.resolve(j.toJsonString())
    }

    @ReactMethod
    fun core_get_text(pinyin_json: String, promise: Promise) {
        val core = pinyin_service?.core()
        if (core == null) {
            val o = json {
                array(emptyList())
            }
            promise.resolve(o.toJsonString())
            return
        }
        // TODO parse json error ?
        val raw = parse_json_array<String>(pinyin_json)
        val pinyin: MutableList<String> = mutableListOf()
        for (i in raw) {
            pinyin.add(i)
        }

        // TODO core Exception ?
        val r = core.pinyin().get_text(pinyin)
        // export json
        val o: MutableList<JsonArray<Any?>> = mutableListOf()
        for (i in r) {
            o.add(json {
                array(i)
            })
        }
        val j = json {
            array(o)
        }
        promise.resolve(j.toJsonString())
    }

    // nolog mode

    @ReactMethod
    fun core_get_nolog(promise: Promise) {
        val core = pinyin_service?.core()
        if (core == null) {
            promise.resolve(null)
            return  // just ignore
        }
        val nolog = core.get_nolog()
        promise.resolve(nolog)
    }

    @ReactMethod
    fun core_set_nolog(nolog: Boolean, promise: Promise) {
        val core = pinyin_service?.core()
        if (core == null) {
            promise.resolve(null)
            return  // just ignore
        }
        core.set_nolog(nolog)
        promise.resolve(true)
    }

    // user model: user input (log)

    @ReactMethod  // get symbol list
    fun core_get_symbol(promise: Promise) {
        // TODO error process ?
        val core = pinyin_service?.core()
        if (core == null) {
            promise.resolve(null)
            return  // just ignore it
        }
        val r = core.symbol().get_list()
        // export json
        val o: MutableList<JsonArray<Any?>> = mutableListOf()
        for (i in r) {
            o.add(json {
                array(i)
            })
        }
        val j = json {
            array(o)
        }
        promise.resolve(j.toJsonString())
    }

    @ReactMethod  // get symbol2 list
    fun core_get_symbol2(promise: Promise) {
        // TODO error process ?
        val core = pinyin_service?.core()
        if (core == null) {
            promise.resolve(null)
            return  // just ignore it
        }
        val r = core.symbol2().get_list()
        // export json
        val o: MutableList<JsonArray<Any?>> = mutableListOf()
        for (i in r) {
            o.add(json {
                array(i)
            })
        }
        val j = json {
            array(o)
        }
        promise.resolve(j.toJsonString())
    }

    // send native event function
    fun send_event(data: JsonObject) {
        try {
            val js_module = getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            js_module.emit(A_PINYIN_NATIVE_EVENT, data.toJsonString())
        } catch (e: Exception) {
            e.printStackTrace()  // ignore error
        }
    }

    // core config

    @ReactMethod
    fun core_config_get_level(promise: Promise) {
        val core = pinyin_service?.core()
        if (core == null) {
            promise.resolve(null)
            return
        }
        val level = core.pinyin().get_level()
        promise.resolve(level)
    }

    @ReactMethod
    fun core_config_set_level(level: Int, promise: Promise) {
        val core = pinyin_service?.core()
        if (core == null) {
            promise.resolve(null)
            return
        }
        core.pinyin().set_level(level)
        promise.resolve(true)
    }

    @ReactMethod
    fun core_clean_user_db(promise: Promise) {
        // TODO process Exception ?
        clean_user_db()
        // FIXME never reject
        promise.resolve(true)
    }

    @ReactMethod
    fun core_get_db_info(promise: Promise) {
        val r = get_db_info()
        // never reject
        promise.resolve(r.toJsonString())
    }

    @ReactMethod
    fun exit_app(promise: Promise) {
        // DEBUG
        println("DEBUG: ImNative.exit_app()")

        System.exit(0)
        // never got here
        promise.resolve(true)
    }
}

class ImPackage : ReactPackage {

    override fun createViewManagers(context: ReactApplicationContext): List<ViewManager<*, *>> {
        return emptyList()
    }

    override fun createNativeModules(context: ReactApplicationContext): List<NativeModule> {
        return listOf(ImNative(context))
    }
}
