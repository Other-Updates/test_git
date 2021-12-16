package com.app.scooteroapp.constants

import android.content.Context
import android.content.SharedPreferences
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKeys

object DevicePreferences {

    private fun getPreference(context: Context,name:String) : SharedPreferences{
        val masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC)
        return EncryptedSharedPreferences.create(
            name,
            masterKeyAlias,
            context,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        )
    }

    private fun SharedPreferences.edit(operation : (SharedPreferences.Editor) -> Unit){
        val editor = edit()
        operation(editor)
        editor.apply()
    }

    fun hasSharedPreference(context: Context,key:String,isBoolean:Boolean = false):Boolean {
        val pref = getPreference(context,Constants.PREFERENCE_NAME)
        return  if(pref.contains(key)){
            if(!isBoolean){
                val value = pref.getString(key,"")
                value?.length != 0
            }else{
                val value = pref.getBoolean(key,false)
                value
            }
        }else {
            false
        }
    }

    fun setSharedPreference(context:Context,key:String,value:Any?){
        val pref = getPreference(context,Constants.PREFERENCE_NAME)
        with(pref) {
            when(value){
                is String -> edit { it.putString(key,value) }
                is Int -> edit  { it.putInt(key,value) }
                is Float -> edit { it.putFloat(key,value) }
                is Boolean -> edit { it.putBoolean(key,value) }
                is Long -> edit {it.putLong(key,value)}
                else ->  edit { it.putString(key,null)}
            }
        }
    }

    fun getSharedPreference(context:Context,key:String,defaultValue:SealedPreference) : Any?{
        val pref = getPreference(context,Constants.PREFERENCE_NAME)
        with(pref){
            return when(defaultValue){
                SealedPreference.STRING ->{
                    getString(key,"")
                }
                SealedPreference.INTEGER ->{
                    getInt(key,0)
                }
                SealedPreference.FLOAT ->{
                    getFloat(key,0f)
                }
                SealedPreference.BOOLEAN ->{
                    getBoolean(key,false)
                }
                SealedPreference.LONG ->{
                    getLong(key,0L)
                }
            }
        }
    }

    fun clearPreference(context: Context){
        val lang = getSharedPreference(context,Constants.LANGUAGE,SealedPreference.STRING) as String
        val langContent = getSharedPreference(context,Constants.LANG_CONTENT,SealedPreference.STRING) as String
        context.getSharedPreferences(Constants.PREFERENCE_NAME,0).edit().clear().commit()
        setSharedPreference(context,Constants.IS_TUTORIAL,true)
        setSharedPreference(context,Constants.LANGUAGE,lang)
        setSharedPreference(context,Constants.LANG_CONTENT,langContent)
    }

}