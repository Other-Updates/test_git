package com.app.scooteroapp.activities

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityChangeNumberBinding
import com.app.scooteroapp.entities.GenerateOTPRequest
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.lang.Exception

class ChangeNumberActivity : AppCompatActivity() {
    lateinit var binding : ActivityChangeNumberBinding
    var scProgressDialog = SCProgressDialog()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityChangeNumberBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()
        binding.btnGenerateOTP.text = UiUtils.langValue(this,"GENERIC_GENERATE_OTP")
        binding.txtTitle.text = UiUtils.langValue(this,"GENERIC_CHANGE_MOBILE_NUMBER")
        binding.edtMobNo.hint = UiUtils.langValue(this,"GENERIC_ENTER_PRESENT_NUMBER")
    //    43242321321
        with(binding){
            btnGenerateOTP.setOnClickListener {
                if(edtMobNo.text.toString().isEmpty()){
                    UiUtils.showToast(this@ChangeNumberActivity,"Enter mobile no")
                }else{
                    val customerId = DevicePreferences.getSharedPreference(this@ChangeNumberActivity,
                        Constants.USER_ID, SealedPreference.STRING) as String
                    val existingNumber = DevicePreferences.getSharedPreference(this@ChangeNumberActivity,Constants.USER_MOB_NO,SealedPreference.STRING) as String
                    val generateOTPRequest = GenerateOTPRequest(customerId,"change mobile",
                        existingNumber,existingNumber)
                    scProgressDialog.showDialog(this@ChangeNumberActivity,"Updating mobile number..")
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            val response = ApiCall.generateOTP(generateOTPRequest)
                            if(response.isSuccessful){
                                if(response.body()?.status == "Success"){
                                    withContext(Dispatchers.Main){
                                        scProgressDialog.dismissDialog()
                                        Intent(this@ChangeNumberActivity,OTPActivity::class.java).apply {
                                            putExtra("OTP",response.body()?.OTP)
                                            putExtra("From","ChangeNumber")
                                            putExtra("mobileNo",edtMobNo.text.toString())
                                        }.also {
                                            startActivity(it)
                                            finish()
                                        }
                                    }
                                    /*val otpReq = DashboardRequest(customerId)
                                    val otpRes = ApiCall.sendOTP(otpReq)
                                    if(otpRes.isSuccessful){

                                    }*/
                                }else{
                                    withContext(Dispatchers.Main){
                                        scProgressDialog.dismissDialog()
                                        UiUtils.showToast(this@ChangeNumberActivity,"Unable to change mobile number");
                                    }
                                }
                            }else{
                                withContext(Dispatchers.Main){
                                    scProgressDialog.dismissDialog()
                                    UiUtils.showToast(this@ChangeNumberActivity,"Unable to change mobile number");
                                }
                            }
                        }catch (e:Exception){
                            e.printStackTrace()
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@ChangeNumberActivity,"Unable to change mobile number");
                            }
                        }
                    }
                }
            }

            imgBack.setOnClickListener {
                finish()
            }
        }
    }
}