package com.app.scooteroapp.activities;



import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import com.app.scooteroapp.R
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.databinding.ActivityResetpassBinding
import com.app.scooteroapp.utility.UiUtils

class ResetpassActivity : AppCompatActivity() {
    lateinit var binding : ActivityResetpassBinding
    var otpStatus : Boolean = false
    var fromScreen : String? = ""
    /*protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_resetpassword);*/


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding =  ActivityResetpassBinding.inflate(layoutInflater)
        getSupportActionBar()?.hide();
        setContentView(binding.root)

        otpStatus = intent.extras?.getBoolean("OTPStatus") == true
        fromScreen = intent.extras?.getString("From")

        if(otpStatus){
            binding.imgAck1.setImageResource(R.drawable.update_profile_success)

                if(fromScreen == Constants.OTP_FORGOT_PASS_TYPE){
                binding.txtAck1.text = UiUtils.langValue(this,"GENERIC_PASSWORD_RESET_LINK")
            }

            Handler().postDelayed({
                runOnUiThread {
                    if (fromScreen == Constants.OTP_FORGOT_PASS_TYPE){
                        Intent(this,LoginActivity::class.java).apply {
                            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }.also {
                            startActivity(it)
                        }

                    }else{
                        finish()
                    }
                }
            },10000)
        }else{
            binding.imgAck1.setImageResource(R.drawable.otpfailed)
            binding.txtAck1.text = UiUtils.langValue(this,"GENERIC_OTP_ERROR")
        }



        initListeners()
    }



    private fun initListeners(){
        binding.btnClose.setOnClickListener{
            if(otpStatus){
                if(fromScreen==Constants.OTP_FORGOT_PASS_TYPE){
                    Intent(this,LoginActivity::class.java).apply{
                        addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                        addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }.also{
                        startActivity(it)
                    }

                }else{
                    finish()
                }
            }else{
                finish()
            }
        }
    }

}






