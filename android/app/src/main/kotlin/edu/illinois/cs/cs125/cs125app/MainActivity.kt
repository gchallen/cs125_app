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
    if (BuildConfig.DEBUG) {
      Log.d("CS125", "Enabling screen on");
      window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
    }
  }

  override fun onDestroy() {
    super.onDestroy()
    if (BuildConfig.DEBUG) {
      Log.d("CS125", "Disabling screen on");
      window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
    }
  }
}
