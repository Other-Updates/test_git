package com.app.scooteroapp.activities

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import androidx.core.view.isVisible
import com.app.scooterapp.activities.DashboardActivity
import com.app.scooteroapp.R
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.databinding.ActivityOTPAckBinding
import com.app.scooteroapp.utility.UiUtils

class OTPAckActivity : AppCompatActivity() {
    lateinit var binding : ActivityOTPAckBinding
    var otpStatus : Boolean = false
    var fromScreen : String? = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityOTPAckBinding.inflate(layoutInflater)
        setContentView(binding.root)

        otpStatus = intent.extras?.getBoolean("OTPStatus") == true
        fromScreen = intent.extras?.getString("From")

        if(otpStatus){
            binding.imgAck.setImageResource(R.drawable.otpsuccess)
            if(fromScreen == "ChangeEmail"){
                binding.txtAck.text = UiUtils.langValue(this,"GENERIC_EMAIL_CHANGES_MSG")
            }else if(fromScreen == "ChangeNumber"){
                binding.txtAck.text = UiUtils.langValue(this,"GENERIC_MOBILE_NUMBER_CHANGED_MSG")
            }else{
                binding.txtAck.text = UiUtils.langValue(this,"GENERIC_OTP_VERIFIED")
            }

            Handler().postDelayed({
                runOnUiThread {
                    if(fromScreen == "Registration"  ){
                        Intent(this, DashboardActivity::class.java).apply {
                            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }.also {
                            startActivity(it)
                        }
                    }else if (fromScreen == Constants.OTP_FORGOT_PASS_TYPE){
                        Intent(this,ResetpassActivity::class.java).apply {
                            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }.also {
                            startActivity(it)
                        }

                    }else if(fromScreen == "ChangeEmail" || fromScreen == "ChangeNumber"){
                        Intent(this,SettingsActivity::class.java).apply {
                            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                        }.also {
                            startActivity(it)
                        }
                    }else{
                        finish()
                    }
                }
            },3000)
        }else{
            binding.imgAck.setImageResource(R.drawable.otpfailed)
            binding.txtAck.text = UiUtils.langValue(this,"GENERIC_OTP_ERROR")
        }
        binding.btnTryAgain.isVisible = !otpStatus
        binding.txtOr.isVisible = !otpStatus
        binding.txtChangeNo.isVisible = !otpStatus
        binding.txtOr2.isVisible = !otpStatus
        binding.txtContactSupport.isVisible = !otpStatus

        binding.btnTryAgain.text = UiUtils.langValue(this,"GENERIC_TRY_AGAIN")
        binding.txtOr.text = UiUtils.langValue(this,"GENERIC_OR")
        binding.txtOr2.text = UiUtils.langValue(this,"GENERIC_OR")
        binding.txtChangeNo.text = UiUtils.langValue(this,"GENERIC_CHANGE_MOBILE_NUMBER")
        binding.txtContactSupport.text = UiUtils.langValue(this,"GENERIC_CONTACT_SUPPORT")
        initListeners()
    }



    private fun initListeners(){
        binding.txtChangeNo.setOnClickListener {
            Intent(this,ChangeMobileNumberActivity::class.java).also {
                startActivity(it)
                finish()
            }
        }
        binding.txtContactSupport.setOnClickListener {
            Intent(this,ContactSupportActivity::class.java).also {
                startActivity(it)
            }
        }
        binding.btnClose.setOnClickListener {
            if(otpStatus){
                if(fromScreen == "Registration" ){
                    Intent(this,DashboardActivity::class.java).apply {
                        addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                        addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }.also {
                        startActivity(it)
                    }
                }else if(fromScreen == Constants.OTP_FORGOT_PASS_TYPE){
                    Intent(this,ResetpassActivity::class.java).apply {
                        addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                        addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }.also {
                        startActivity(it)
                    }

                    }else if(fromScreen == "ChangeEmail" || fromScreen == "ChangeNumber"){
                    Intent(this,SettingsActivity::class.java).apply {
                        addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    }.also {
                        startActivity(it)
                    }
                }else{
                    finish()
                }
            }else{
                finish()
            }
        }

        binding.btnTryAgain.setOnClickListener {
            finish()
        }
    }
}