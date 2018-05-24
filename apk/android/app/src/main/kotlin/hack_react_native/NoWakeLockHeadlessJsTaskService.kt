package org.sceext.a_pinyin.hack_react_native

import com.facebook.react.HeadlessJsTaskService
import com.facebook.react.ReactInstanceManager

// copy code from https://github.com/facebook/react-native/blob/master/ReactAndroid/src/main/java/com/facebook/react/HeadlessJsTaskService.java
// and modified
/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import java.util.concurrent.CopyOnWriteArraySet

import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.IBinder
import android.os.PowerManager

import com.facebook.infer.annotation.Assertions
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.UiThreadUtil
import com.facebook.react.jstasks.HeadlessJsTaskEventListener
import com.facebook.react.jstasks.HeadlessJsTaskConfig
import com.facebook.react.jstasks.HeadlessJsTaskContext


// NOTE this hack to avoid WakeLock is for react-native 0.55.4
abstract class NoWakeLockHeadlessJsTaskService : HeadlessJsTaskService(), HeadlessJsTaskEventListener {

    val mActiveTasks = CopyOnWriteArraySet<Int>()

    open override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        val taskConfig = getTaskConfig(intent)
        if (taskConfig != null) {
            startTask(taskConfig)
            return START_REDELIVER_INTENT
        }
        return START_NOT_STICKY
    }

    open override fun startTask(taskConfig: HeadlessJsTaskConfig) {
        UiThreadUtil.assertOnUiThread()
        //acquireWakeLockNow(this)  // NOTE remove this line !!!
        val reactInstanceManager =
            getReactNativeHost().getReactInstanceManager()
        val reactContext = reactInstanceManager.getCurrentReactContext()
        if (reactContext == null) {
            reactInstanceManager.addReactInstanceEventListener(object: ReactInstanceManager.ReactInstanceEventListener {
                override fun onReactContextInitialized(reactContext: ReactContext) {
                    invokeStartTask(reactContext, taskConfig)
                    reactInstanceManager.removeReactInstanceEventListener(this)
                }
            })
            if (!reactInstanceManager.hasStartedCreatingInitialContext()) {
                reactInstanceManager.createReactContextInBackground()
            }
        } else {
            invokeStartTask(reactContext, taskConfig)
        }
    }

    open fun invokeStartTask(reactContext: ReactContext, taskConfig: HeadlessJsTaskConfig) {
        val headlessJsTaskContext = HeadlessJsTaskContext.getInstance(reactContext)
        headlessJsTaskContext.addTaskEventListener(this)

        UiThreadUtil.runOnUiThread(object: Runnable {
            override fun run() {
                val taskId = headlessJsTaskContext.startTask(taskConfig)
                mActiveTasks.add(taskId)
            }
        })
    }

    //@Override
    //public void onDestroy() {
    //    super.onDestroy();
    //}

    //@Override
    //public void onHeadlessJsTaskStart(int taskId) { }

    open override fun onHeadlessJsTaskFinish(taskId: Int) {
        mActiveTasks.remove(taskId)
        if (mActiveTasks.size == 0) {
            stopSelf()
        }
    }
}
