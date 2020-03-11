package com.example.final_app;
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import android.widget.Toast
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivityNew : FlutterActivity() {
    private var mService: Intent? = null;
    private val mStartService = "startService"
    private val mStopService = "stopService"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.google_sign_in_app")
                .setMethodCallHandler { call, result ->
                    if (call.method == mStartService) {
                        startService()
                        result.success(" $mStartService= ${getBatteryInfo()}")
                    } else if(call.method == mStopService){
                        stopService()
                        result.success("stopService")
                    }
                }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        this.mService = Intent(this, MyService()::class.java)

    }

    fun getBatteryInfo(): Int {
        val batteryLevel: Int
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

//        Toast.makeText(context, "Battery level $batteryLevel", Toast.LENGTH_LONG).show()
        return batteryLevel
    }

    fun startService() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(mService)
        } else {
            startService(mService)
        }
    }

    fun stopService() {
        stopService(mService)
    }
}
