package com.app.scooteroapp.activities

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityChangeEmailBinding
import com.app.scooteroapp.entities.DashboardRequest
import com.app.scooteroapp.entities.GenerateOTPRequest
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.lang.Exception

/*
class ChangeEmailActivity : AppCompatActivity() {
    lateinit var binding : ActivityChangeEmailBinding
    var scProgressDialog = SCProgressDialog()

    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityChangeEmailBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()
        binding.txtTitle.text = UiUtils.langValue(this,"GENERIC_CHANGE_EMAIL_ID")
        binding.edtEmailId.hint = UiUtils.langValue(this,"GENERIC_ENTER_PRESENT_EMAIL")
        binding.btnGenerateOTP.text = UiUtils.langValue(this,"GENERIC_GENERATE_OTP")

        with(binding){
            btnGenerateOTP.setOnClickListener {
                if(edtEmailId.text.toString().isEmpty()){
                    UiUtils.showToast(this@ChangeEmailActivity,"Enter email ID")
                }else{


                    val customerId = DevicePreferences.getSharedPreference(this@ChangeEmailActivity,Constants.USER_ID,SealedPreference.STRING) as String
                    val existingNumber = DevicePreferences.getSharedPreference(this@ChangeEmailActivity,Constants.USER_MOB_NO,SealedPreference.STRING) as String
                    val existingEmail = DevicePreferences.getSharedPreference(this@ChangeEmailActivity,Constants.USER_EMAIL,SealedPreference.STRING) as String
                    val generateOTPRequest = GenerateOTPRequest(customerId ,"change email",
                        existingNumber,existingEmail)
                    scProgressDialog.showDialog(this@ChangeEmailActivity,"Updating email address..")
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            val response = ApiCall.generateOTP(generateOTPRequest)
                            if(response.isSuccessful){
                                if(response.body()?.status == "Success"){
                                    withContext(Dispatchers.Main){
                                      //  scProgressDialog.dismissDialog()
                                        Intent(this@ChangeEmailActivity,OTPActivity::class.java).apply {
                                            putExtra("OTP",response.body()?.OTP)
                                            putExtra("From","ChangeEmail")
                                            putExtra("email",edtEmailId.text.toString())
                                        }.also {
                                            startActivity(it)
                                            finish()
                                        }
                                    }
*/
/*val otpReq = DashboardRequest(customerId)
                                    val otpRes = ApiCall.sendOTP(otpReq)
                                    if(otpRes.isSuccessful){

                                    }*//*


                                }else{
                                    withContext(Dispatchers.Main){
                                        scProgressDialog.dismissDialog()
                                        UiUtils.showToast(this@ChangeEmailActivity,"Unable to change email address");
                                    }
                                }
                            }else{
                                withContext(Dispatchers.Main){
                                    scProgressDialog.dismissDialog()
                                    UiUtils.showToast(this@ChangeEmailActivity,"Unable to change email address");
                                }
                            }
                        }catch (e: Exception){
                            e.printStackTrace()
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@ChangeEmailActivity,"Unable to change email address");
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
*/


class ChangeEmailActivity : AppCompatActivity() {
    lateinit var binding : ActivityChangeEmailBinding
    var scProgressDialog = SCProgressDialog()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityChangeEmailBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()
        binding.txtTitle.text = UiUtils.langValue(this,"GENERIC_CHANGE_EMAIL_ID")
        binding.edtEmailId.hint = UiUtils.langValue(this,"GENERIC_ENTER_PRESENT_EMAIL")
        binding.btnGenerateOTP.text = UiUtils.langValue(this,"GENERIC_GENERATE_OTP")


        with(binding){
            btnGenerateOTP.setOnClickListener {
                if(edtEmailId.text.toString().isEmpty()){
                    UiUtils.showToast(this@ChangeEmailActivity,"Enter email ID")
                }else {
                    val customerId = DevicePreferences.getSharedPreference(this@ChangeEmailActivity, Constants.USER_ID, SealedPreference.STRING) as String


                    val generateOTPRequest = GenerateOTPRequest(customerId, "change email", edtEmailId.text.toString())
                    scProgressDialog.showDialog(this@ChangeEmailActivity,
                        "Updating email address..")
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            val response = ApiCall.generateOTP(generateOTPRequest)
                            //    val response =ApiCall.changeEmailAddress(changeEmailRequest)
                            if (response.isSuccessful) {

                                Log.d("success", "123456" + response.body())
                                if (response.body()?.status == "Success") {

                                    /*  DevicePreferences.setSharedPreference(
                                        this@ChangeEmailActivity,
                                        Constants.USER_EMAIL,
                                        edtEmailId.text.toString()
                                    )

                                    UiUtils.showToast(
                                        this@ChangeEmailActivity,
                                        response.body()?.message.toString()
                                    )*/

                                    val otpReq = DashboardRequest(customerId)
                                    val otpRes = ApiCall.sendOTP(otpReq)
                                    //       if (otpRes.isSuccessful) {

                                    withContext(Dispatchers.Main) {
                                        scProgressDialog.dismissDialog()
                                        Intent(this@ChangeEmailActivity, OTPActivity::class.java
                                        ).apply {
                                            putExtra("OTP", otpRes.body()?.OTP)
                                            putExtra("From", "ChangeEmail")
                                            putExtra("email",edtEmailId.text.toString())


                                            // addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_NEW_TASK)


                                        }.also {
                                            startActivity(it)
                                            finish()
                                        }

                                    }
                                    //  }
                                    //   }
                                } else {
                                    withContext(Dispatchers.Main) {
                                        scProgressDialog.dismissDialog()
                                        UiUtils.showToast(this@ChangeEmailActivity, "Unable to change email address")
                                    }
                                }

                            }else{
                                withContext(Dispatchers.Main) {
                                    scProgressDialog.dismissDialog()
                                    UiUtils.showToast(
                                        this@ChangeEmailActivity,
                                        "Unable to change email address"
                                    );
                                }
                            }

                        }catch (e: Exception) {
                            e.printStackTrace()
                            withContext(Dispatchers.Main) {
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(
                                    this@ChangeEmailActivity,
                                    "Unable to change email address"
                                )
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

