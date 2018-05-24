package org.sceext.a_pinyin

import android.os.Bundle
import android.content.Intent

import com.facebook.react.ReactActivity


class MainActivity : ReactActivity() {

    /**
     * Returns the name of the main component registered from JavaScript.
     * This is used to schedule rendering of the component.
     */
    override fun getMainComponentName(): String? {
        return "a_pinyin_main"
    }
}
