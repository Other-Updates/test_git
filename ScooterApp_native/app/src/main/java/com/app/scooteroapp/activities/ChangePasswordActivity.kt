package com.app.scooteroapp.activities

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityChangeNumberBinding
import com.app.scooteroapp.databinding.ActivityChangePasswordBinding
import com.app.scooteroapp.entities.ChangePasswordRequest
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/*
class ChangePasswordActivity : AppCompatActivity() {
    lateinit var binding : ActivityChangePasswordBinding
    val scProgressDialog = SCProgressDialog()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityChangePasswordBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()
        with(binding){
            btnSubmit.setOnClickListener {
                if(edtCurrentPassword.text.toString().isEmpty()){
                    UiUtils.showToast(this@ChangePasswordActivity,"Enter current password")
                }else if(edtNewPassword.text.toString().isEmpty()){
                    UiUtils.showToast(this@ChangePasswordActivity,"Enter new password")
                }else if(edtConfirmPassword.text.toString() != edtNewPassword.text.toString()){
                    UiUtils.showToast(this@ChangePasswordActivity,"Confirm password not matches")
                }else if(edtCurrentPassword.text.toString() !=
                        DevicePreferences.getSharedPreference(this@ChangePasswordActivity,Constants.PASSWORD,SealedPreference.STRING) as String){
                    UiUtils.showToast(this@ChangePasswordActivity,"Incorrect current password")
                }else if(edtNewPassword.text.toString().length < 6){
                    UiUtils.showToast(this@ChangePasswordActivity,"Password should be minimum 6 letters")
                }else{
                    val changePasswordRequest = ChangePasswordRequest().apply {
                        id = DevicePreferences.getSharedPreference(this@ChangePasswordActivity,Constants.USER_ID,SealedPreference.STRING) as String
                        old_password = edtCurrentPassword.text.toString()
                        new_password = edtNewPassword.text.toString()
                    }
                    scProgressDialog.showDialog(this@ChangePasswordActivity,"Please wait while changing password...")
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            val response = ApiCall.changePassword(changePasswordRequest)
                            if(response.isSuccessful){
                                withContext(Dispatchers.Main){
                                    scProgressDialog.dismissDialog()
                                    if(response.body()?.status == "Success"){
                                        DevicePreferences.setSharedPreference(this@ChangePasswordActivity,Constants.PASSWORD,changePasswordRequest.new_password)
                                        UiUtils.showToast(this@ChangePasswordActivity,response.body()?.message.toString())
                                        finish()
                                    }else{
                                        UiUtils.showToast(this@ChangePasswordActivity,response.body()?.message.toString())
                                    }
                                }
                            }else{
                                withContext(Dispatchers.Main){
                                    scProgressDialog.dismissDialog()
                                    UiUtils.showToast(this@ChangePasswordActivity,"Unable to change password")
                                }
                            }
                        }catch (e:Exception){
                            e.printStackTrace()
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@ChangePasswordActivity,"Unable to change password")
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
}*/

class ChangePasswordActivity : AppCompatActivity() {
    lateinit var binding : ActivityChangePasswordBinding
    val scProgressDialog = SCProgressDialog()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityChangePasswordBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()
        with(binding){
            btnSubmit.setOnClickListener {
                if(edtCurrentPassword.text.toString().isEmpty()){
                    UiUtils.showToast(this@ChangePasswordActivity,"Enter current password")
                }else if(edtNewPassword.text.toString().isEmpty()){
                    UiUtils.showToast(this@ChangePasswordActivity,"Enter new password")
                }else if(edtConfirmPassword.text.toString() != edtNewPassword.text.toString()){
                    UiUtils.showToast(this@ChangePasswordActivity,"Confirm password not matches")
                }else if(edtCurrentPassword.text.toString() !=
                    DevicePreferences.getSharedPreference(this@ChangePasswordActivity,Constants.PASSWORD,SealedPreference.STRING) as String){
                    UiUtils.showToast(this@ChangePasswordActivity,"Incorrect current password")
                }else if(edtNewPassword.text.toString().length < 6){
                    UiUtils.showToast(this@ChangePasswordActivity,"Password should be minimum 6 letters")
                }else{
                    val changePasswordRequest = ChangePasswordRequest().apply {
                        id = DevicePreferences.getSharedPreference(this@ChangePasswordActivity,Constants.USER_ID,
                            SealedPreference.STRING) as String
                        old_password = edtCurrentPassword.text.toString()
                        new_password = edtNewPassword.text.toString()
                    }
                    scProgressDialog.showDialog(this@ChangePasswordActivity,"Please wait while changing password...")
                    CoroutineScope(Dispatchers.IO).launch {
                       // try {
                            val response = ApiCall.changePassword(changePasswordRequest)


                            if(response.isSuccessful){
                                withContext(Dispatchers.Main){
                                    scProgressDialog.dismissDialog()
                                    if(response.body()?.status == "Success"){
                                        DevicePreferences.setSharedPreference(this@ChangePasswordActivity,
                                            Constants.PASSWORD,changePasswordRequest.new_password)
                                        UiUtils.showToast(this@ChangePasswordActivity,response.body()?.message.toString())
                                        finish()
                                    }else{
                                        UiUtils.showToast(this@ChangePasswordActivity,response.body()?.message.toString())
                                    }
                                }
                            }else{
                                withContext(Dispatchers.Main){
                                    scProgressDialog.dismissDialog()
                                    UiUtils.showToast(this@ChangePasswordActivity,"Unable to change password")
                                }
                            }
                     //   }/*catch (e:Exception){
                            //e.printStackTrace()
                           // withContext(Dispatchers.Main){
                           //     scProgressDialog.dismissDialog()
                           //     UiUtils.showToast(this@ChangePasswordActivity,"Unable to change password")
                          //  }
                     //   }*/
                    }
                }
            }

            imgBack.setOnClickListener {
                finish()
            }
        }
    }
}
