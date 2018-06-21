package edu.illinois.cs.cs125.cs125app

import android.os.Bundle
import android.os.Debug
import android.util.Log
import android.view.WindowManager

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
  }

  override fun onResume() {
    super.onResume()
    if (BuildConfig.DEBUG) { // don't even consider it otherwise
      if (Debug.isDebuggerConnected()) {
        Log.d("SCREEN", "Keeping screen on for debugging, detach debugger and force an onResume to turn it off.")
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
      } else {
        window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        Log.d("SCREEN", "Keeping screen on for debugging is now deactivated.")
      }
    }
  }
}
