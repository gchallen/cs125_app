package edu.illinois.cs.cs125.cs125app

import android.content.Intent
import android.util.Log
import io.flutter.app.FlutterApplication
import io.intheloup.beacons.BeaconsPlugin
import io.intheloup.beacons.data.BackgroundMonitoringEvent

class App : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()

        // Beacons setup for Android
        BeaconsPlugin.init(this, object : BeaconsPlugin.BackgroundMonitoringCallback {
            override fun onBackgroundMonitoringEvent(event: BackgroundMonitoringEvent): Boolean {
                Log.d("CS125", "Heard beacon in background");
                return true
            }
        })
    }
}