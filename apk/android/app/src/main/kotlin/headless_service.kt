package org.sceext.a_pinyin

import android.content.Intent

import com.facebook.react.jstasks.HeadlessJsTaskConfig

import org.sceext.a_pinyin.hack_react_native.NoWakeLockHeadlessJsTaskService


class BgJsService : NoWakeLockHeadlessJsTaskService() {

    override fun getTaskConfig(intent: Intent): HeadlessJsTaskConfig? {
        return HeadlessJsTaskConfig(
            "headless_bg_task",  // task name
            null,  // task data
            0,  // no timeout (allow run forever)
            true)  // allow task to run in foreground
    }
}
