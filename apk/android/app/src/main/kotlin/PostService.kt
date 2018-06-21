package org.sceext.a_pinyin

import android.app.Service
import android.content.Intent
import android.os.IBinder

import org.sceext.a_pinyin.post.PostBinder


class PostService() : Service() {

    private lateinit var _binder: PostBinder

    override fun onCreate() {
        super.onCreate()

        _binder = PostBinder()
    }

    override fun onBind(intent: Intent): IBinder {
        return _binder;
    }
}
