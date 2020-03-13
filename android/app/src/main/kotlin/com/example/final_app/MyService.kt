package com.example.final_app;
import android.app.Service
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.widget.Toast
import androidx.core.app.NotificationCompat
import java.util.*
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

val mHandlerThread = Handler()
var mContext: Context? = null

class MyService : Service() {
    private val content = "service running in background"
    private val title = "Uploading device Info"
    private val id = 101

    private val notifyTimeInterval: Long = 10 * 1000 // 10 seconds
    private var mTimer: Timer? = null

    override fun onCreate() {
        super.onCreate()
        mContext = this;
//        GeneratedPluginRegistrant.registerWith(this)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val builder = NotificationCompat.Builder(this, "messages")
                    .setContentText(content)
                    .setContentTitle(title)
//                    .setSmallIcon(R.drawable.launch_background)
            startForeground(id, builder.build())
        }

        if (mTimer != null) {
            mTimer!!.cancel()
        } else {
            mTimer = Timer()
        }
//        database = Firebase.database.reference
        mTimer!!.scheduleAtFixedRate(TimeDisplayTimerTask(), 10, notifyTimeInterval);
    }

    class TimeDisplayTimerTask : TimerTask() {
        override fun run() {
            //To change body of created functions use File | Settings | File Templates.
            mHandlerThread.post(Runnable {
                var batteryLevel: Int = 0

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    val batteryManager = mContext!!.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
                    batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
                } else {
                    val intent = ContextWrapper(mContext!!.applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
                    batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
                }
//                val method_channel = MethodChannel(mContext.getFlutterView(), "com.example.google_sign_in_app")
//                method_channel.invokeMethod("didRecieveTranscript", "utterance")

//                database.child("Device Info").child("a3b338935a55b177")
//                database..child("batteryLvevel").setValue(batteryLevel)

//                val mDatabase: FirebaseDatabase = Firebase.database.reference
//                val mDatabaseReference: DatabaseReference? = mDatabase.child("Device Info").child("a3b338935a55b177")
//                mDatabaseReference!!.child("batteryLvevel")!!.setValue(batteryLevel)

//                var methodChannel = MethodChannel("com.example.google_sign_in_app").invokeMethod ("didRecieveTranscript")

                android.util.Log.d("tiemr", "Time task execute \n Battery Level == $batteryLevel")
                Toast.makeText(mContext, "Time task execute \n Battery Level == $batteryLevel", android.widget.Toast.LENGTH_SHORT).show()
            })
        }

    }

    override fun onBind(intent: Intent?): IBinder? {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun onDestroy() {
        super.onDestroy()
        mTimer!!.cancel()
    }
}