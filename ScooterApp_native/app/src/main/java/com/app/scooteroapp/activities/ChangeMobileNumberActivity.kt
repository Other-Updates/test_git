package com.app.scooteroapp.activities

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.app.scooteroapp.databinding.ActivityChangeMobileNumberBinding
import com.app.scooteroapp.entities.ForgotRequest
import com.app.scooteroapp.entities.GenerateOTPRequest
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class ChangeMobileNumberActivity : AppCompatActivity() {
    lateinit var binding : ActivityChangeMobileNumberBinding
    lateinit var activityContext : Context
    var fromScreen:String? = ""
    var customerId:String? = ""
    var scProgressDialog = SCProgressDialog()
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityChangeMobileNumberBinding.inflate(layoutInflater)
        setContentView(binding.root)
        activityContext = this
        
        if(intent.hasExtra("From")){
            fromScreen = intent.extras?.getString("From")
        }
        if(intent.hasExtra("customerId")){
            customerId = intent.extras?.getString("customerId")
        }
        
        with(binding){
            txtTitle.text = UiUtils.langValue(activityContext,"GENERIC_CHANGE_MOBILE_NUMBER")
            edtMobNo.hint = UiUtils.langValue(activityContext,"GENERIC_ENTER_MOBILE_NUMBER")
            btnGenerateOTP.text = UiUtils.langValue(activityContext,"GENERIC_GENERATE_OTP")
            txtLogin.text = UiUtils.langValue(activityContext,"GENERIC_ALREADY_HAVE_ACCOUNT")
            txtOr.text = UiUtils.langValue(activityContext,"GENERIC_OR")
            txtRegister.text = UiUtils.langValue(activityContext,"GENERIC_NEW_USER_REGISTER")
        }

        binding.txtLogin.setOnClickListener {
            Intent(this,LoginActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_NEW_TASK)
            }.also {
                startActivity(it)
                finish()
            }
        }
        binding.txtRegister.setOnClickListener {
            Intent(this,RegistrationActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_NEW_TASK)
            }.also {
                startActivity(it)
                finish()
            }
        }
        binding.btnGenerateOTP.setOnClickListener {
            if(binding.edtMobNo.text.toString().isEmpty()){
                UiUtils.showToast(this,"Enter mobile number")
            }else if(binding.edtMobNo.text.toString().length < 6){
                UiUtils.showToast(this,"Enter valid mobile number")
            }else{
                resendOTP()
            }
        }
    }

    private fun resendOTP(){
        scProgressDialog.showDialog(this@ChangeMobileNumberActivity,"Please wait resending OTP..")
        val forgetRequest = ForgotRequest(binding.edtMobNo.text.toString())
        CoroutineScope(Dispatchers.IO).launch {
            val response = ApiCall.forgotPassword(forgetRequest)
            if(response.isSuccessful){
                if(response.body()?.status == "Success"){
                    val generateOTPRequest = GenerateOTPRequest(response.body()?.data?.id!!,"forget password",
                        binding.edtMobNo.text.toString(),binding.edtMobNo.text.toString())
                    /*val otpReq = DashboardRequest(response.body()?.data?.id!!)
                    val otpRes = ApiCall.sendOTP(otpReq)*/
                    val otpRes= ApiCall.generateOTP(generateOTPRequest)
                    if(otpRes.isSuccessful){
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            Intent(this@ChangeMobileNumberActivity,OTPActivity::class.java).apply {
                                putExtra("OTP",otpRes.body()?.OTP)
                                putExtra("From",fromScreen)
                                putExtra("customerId",response.body()?.data?.id)
                                putExtra("mobileNo",binding.edtMobNo.text.toString())
                                addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_NEW_TASK)
                            }.also {
                                startActivity(it)
                                finish()
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@ChangeMobileNumberActivity,"Error sending OTP")
                        }
                    }
                }else{
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@ChangeMobileNumberActivity,response.body()?.message.toString())
                    }
                }
            }else{
                withContext(Dispatchers.Main){
                    scProgressDialog.dismissDialog()
                    UiUtils.showToast(this@ChangeMobileNumberActivity,"Error verifying mobile number")
                }
            }
        }
    }
}