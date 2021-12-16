package com.app.scooteroapp.utility

import android.text.TextUtils
import android.util.Patterns
import java.util.*
import kotlin.collections.ArrayList

object CommonUtils {
    fun isValidEmail(emailAddress:String):Boolean {
        return (!TextUtils.isEmpty(emailAddress) && Patterns.EMAIL_ADDRESS.matcher(emailAddress).matches())
    }

    fun timeDiff(startDate: Date, endDate: Date):String{
        val format = "%1$02d"
        var different: Long = endDate.getTime() - startDate.getTime()
        val secondsInMilli: Long = 1000
        val minutesInMilli = secondsInMilli * 60
        val hoursInMilli = minutesInMilli * 60
        val daysInMilli = hoursInMilli * 24
        val elapsedDays = different / daysInMilli
        different %= daysInMilli
        val elapsedHours = different / hoursInMilli
        different %= hoursInMilli
        val elapsedMinutes = different / minutesInMilli
        different %= minutesInMilli
        val elapsedSeconds = different / secondsInMilli
        return "${elapsedDays}_${String.format(format,elapsedHours)}:" +
                "${String.format(format,elapsedMinutes)}:" +
                "${String.format(format,elapsedSeconds)}"
    }

    fun timeDiffMilli(startDate: Date, endDate: Date):Long{
        val format = "%1$02d"
        var different: Long = endDate.getTime() - startDate.getTime()
        return different
    }

    fun milliDiff(remainingTime:Long) : String{
        val format = "%1$02d"
        var different: Long = remainingTime
        val secondsInMilli: Long = 1000
        val minutesInMilli = secondsInMilli * 60
        val hoursInMilli = minutesInMilli * 60
        val daysInMilli = hoursInMilli * 24
        val elapsedDays = different / daysInMilli
        different %= daysInMilli
        val elapsedHours = different / hoursInMilli
        different %= hoursInMilli
        val elapsedMinutes = different / minutesInMilli
        different %= minutesInMilli
        val elapsedSeconds = different / secondsInMilli
        return "${elapsedDays}_${String.format(format,elapsedHours)}:" +
                "${String.format(format,elapsedMinutes)}:" +
                "${String.format(format,elapsedSeconds)}"
    }

    fun milliDiffPrePaid(remainingTime:Long) : String{
        val format = "%1$02d"
        var different: Long = remainingTime
        val secondsInMilli: Long = 1000
        val minutesInMilli = secondsInMilli * 60
        val hoursInMilli = minutesInMilli * 60
        val daysInMilli = hoursInMilli * 24
        val elapsedDays = different / daysInMilli
        different %= daysInMilli
        val elapsedHours = different / hoursInMilli
        different %= hoursInMilli
        val elapsedMinutes = different / minutesInMilli
        different %= minutesInMilli
        val elapsedSeconds = different / secondsInMilli

        if(elapsedMinutes == 0L){
            return "$elapsedSeconds Seconds"
        }else{
            return "$elapsedMinutes Minutes"
        }
    }

    fun calculateDistance(list:ArrayList<Float>) : String{
        val res = list.sum()
        if(res < 100){
            return "${String.format("%.02f", res)}m"
        }else{
            val km = res/1000F
            return "${String.format("%.02f", km)}km"
        }
    }
}