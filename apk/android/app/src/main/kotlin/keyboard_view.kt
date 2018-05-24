package org.sceext.a_pinyin

import android.view.View

import com.facebook.react.ReactRootView


const val KEYBOARD_VIEW: String = "keyboard_view"

class KeyboardView(val service: PinyinService) {
    val _root_view: ReactRootView = ReactRootView(service)

    var _attached: Boolean = false

    fun getView(): View = _root_view

    fun onDestroy() {
        _root_view.unmountReactApplication()
    }

    fun onShow() {
        if (! _attached) {
            _root_view.startReactApplication(
                app_context().reactNativeHost.reactInstanceManager,
                KEYBOARD_VIEW, null)
            _attached = true
        }
        // else: nothing todo
    }

    fun onHide() {
        // TODO
    }
}
