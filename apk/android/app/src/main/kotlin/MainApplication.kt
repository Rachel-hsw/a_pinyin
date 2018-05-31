package org.sceext.a_pinyin

import java.util.Arrays

import android.app.Application
import android.content.Intent

import com.facebook.react.ReactApplication
import com.facebook.react.ReactNativeHost
import com.facebook.react.ReactPackage
import com.facebook.react.shell.MainReactPackage
import com.facebook.soloader.SoLoader

import com.RNFetchBlob.RNFetchBlobPackage


// save MainApplication instance
var _app_context: MainApplication? = null

fun app_context(): MainApplication = _app_context!!


class MainApplication : Application(), ReactApplication {

    private val mReactNativeHost = object: ReactNativeHost(this) {
        override fun getUseDeveloperSupport(): Boolean {
            return BuildConfig.DEBUG
        }

        override fun getPackages(): List<ReactPackage> {
            return Arrays.asList(
                MainReactPackage(),
                RNFetchBlobPackage(),
                ImPackage()
            )
        }

        override fun getJSMainModuleName(): String {
            return "index"
        }
    }

    override fun getReactNativeHost(): ReactNativeHost {
        return mReactNativeHost
    }

    override fun onCreate() {
        super.onCreate()
        SoLoader.init(this, /* native exopackage */ false)

        _app_context = this
    }
}
