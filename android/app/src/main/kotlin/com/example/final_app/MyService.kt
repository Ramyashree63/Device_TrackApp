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

val mHandlerThread = Handler()
var mContext: Context? = null
class MyService : Service() {
    private val content = "service running in background"
    private val title = "Uploading device Info"
    private val id = 101

    private val notifyTimeInterval: Long = 1 * 1000 // 10 seconds
    private var mTimer: Timer? = null

    override fun onCreate() {
        super.onCreate()
        mContext = this;
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
                
//                val mDatabase: FirebaseDatabase = Firebase.database.reference
//                val mDatabaseReference: DatabaseReference? = mDatabase.child("Device Info")
//                mDatabaseReference!!.child("batteryLvevel")!!.setValue(batteryLevel)

                Toast.makeText(mContext, "Time task execute \n Battery Level == $batteryLevel", Toast.LENGTH_LONG).show()
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