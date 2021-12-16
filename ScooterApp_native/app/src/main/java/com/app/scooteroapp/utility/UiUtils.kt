package com.app.scooteroapp.utility


import android.content.Context
import android.widget.Toast
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import org.json.JSONObject
import java.lang.Exception

object UiUtils {

    fun showToast(context: Context,message:String){
        Toast.makeText(context,message, Toast.LENGTH_SHORT).show()
    }

    fun langValue(context: Context?,key:String):String{
        try {
            context?.let {
                val langContent = DevicePreferences.getSharedPreference(context,Constants.LANG_CONTENT,SealedPreference.STRING) as String
                val langObj = JSONObject(langContent)
                return langObj.getString(key)
            }?: kotlin.run {
                return ""
            }
        }catch (e:Exception){
            e.printStackTrace()
            return ""
        }
    }
}