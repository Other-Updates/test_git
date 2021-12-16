package com.app.scooteroapp.activities

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import androidx.biometric.BiometricConstants
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import com.app.scooterapp.activities.DashboardActivity
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivitySplashBinding
import com.app.scooteroapp.room.LocalDatabase
import com.app.scooteroapp.utility.UiUtils
import java.util.concurrent.Executors

class SplashActivity : AppCompatActivity() {
    lateinit var binding : ActivitySplashBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySplashBinding.inflate(layoutInflater)
        setContentView(binding.root)

        if((DevicePreferences.getSharedPreference(this,Constants.LANGUAGE,SealedPreference.STRING) as String).isNotEmpty()){
            binding.txtCorp.text = UiUtils.langValue(this,"GENERIC_SPLASH")
        }
        Handler().postDelayed({
            if(DevicePreferences.getSharedPreference(this,Constants.LANGUAGE,SealedPreference.STRING) as String == ""){
                Intent(this@SplashActivity,LanguageActivity::class.java).also {
                    startActivity(it)
                    finish()
                }
            }else if(!(DevicePreferences.getSharedPreference(this,Constants.IS_TUTORIAL,SealedPreference.BOOLEAN) as Boolean)){
                Intent(this@SplashActivity,TutorialActivity::class.java).also {
                    startActivity(it)
                    finish()
                }
            }else if(!(DevicePreferences.getSharedPreference(this,Constants.IS_LOGGED_IN,SealedPreference.BOOLEAN) as Boolean)){
                Intent(this@SplashActivity,LoginActivity::class.java).also {
                    startActivity(it)
                    finish()
                }
            }else{
                when(isFingerPrintSupported(this)){
                    BiometricManager.BIOMETRIC_SUCCESS -> {
                        val info =  BiometricPrompt.PromptInfo.Builder()
                            .setTitle("Authenticate")
                            .setSubtitle("Authenticate with ScooterO")
                            .setDescription("Touch your finger on the finger print sensor to authorise your account.")
                            .setNegativeButtonText("Cancel")
                            .build()

                        var biometricPrompt = BiometricPrompt(this, Executors.newSingleThreadExecutor(),
                            object : BiometricPrompt.AuthenticationCallback() {
                                override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                                    super.onAuthenticationSucceeded(result)
                                    runOnUiThread {
                                        navigate()
                                    }
                                }

                                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                                    super.onAuthenticationError(errorCode, errString)
                                    if(errorCode == BiometricConstants.ERROR_USER_CANCELED){
                                        navigate(false)
                                    }else if(errorCode == BiometricConstants.ERROR_NEGATIVE_BUTTON){
                                        navigate(false)
                                    }else if(errorCode == BiometricConstants.ERROR_NO_DEVICE_CREDENTIAL){
                                        runOnUiThread {
                                            navigate()
                                        }
                                    }else if(errorCode == BiometricConstants.ERROR_CANCELED){
                                        runOnUiThread {
                                            navigate()
                                        }
                                    }
                                }

                                override fun onAuthenticationFailed() {
                                    super.onAuthenticationFailed()
                                    navigate(false)
                                }
                            })

                        biometricPrompt.authenticate(info)
                    }
                    BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED -> navigate()
                    else -> navigate()
                }
            }
        },1000)
    }

    fun isFingerPrintSupported(context: Context) : Int{
        val biometricManager = BiometricManager.from(context)
        return biometricManager.canAuthenticate()
    }

    private fun navigate(isSuccess:Boolean = true){
        if(isSuccess){
            if(DevicePreferences.getSharedPreference(this,Constants.LANGUAGE,SealedPreference.STRING) as String == ""){
                Intent(this@SplashActivity,LanguageActivity::class.java).also {
                    startActivity(it)
                    finish()
                }
            }else if(!(DevicePreferences.getSharedPreference(this,Constants.IS_TUTORIAL,SealedPreference.BOOLEAN) as Boolean)){
                Intent(this@SplashActivity,TutorialActivity::class.java).also {
                    startActivity(it)
                    finish()
                }
            }else if(!(DevicePreferences.getSharedPreference(this,Constants.IS_LOGGED_IN,SealedPreference.BOOLEAN) as Boolean)){
                Intent(this@SplashActivity,LoginActivity::class.java).also {
                    startActivity(it)
                    finish()
                }
            }else{
                val localDatabase = LocalDatabase.getAppDatabase(this)
                var openTrip = localDatabase?.appDao()?.openTrip(false)
                if(openTrip?.tripNo?.isNotEmpty() == true){
                    if(openTrip?.tripPaymentType == "Credit"){
                        Intent(this@SplashActivity,RidePostPaidActivity::class.java).also {
                            startActivity(it)
                            finish()
                        }
                    }else{
                        Intent(this@SplashActivity,RidePrePaidActivity::class.java).also {
                            startActivity(it)
                            finish()
                        }
                    }
                }else{
                    Intent(this@SplashActivity, DashboardActivity::class.java).also {
                        startActivity(it)
                        finish()
                    }
                }
            }
        }else{
            Intent(this@SplashActivity,BiometricActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            }.also {
                startActivity(it)
                finish()
            }
        }
    }


}





