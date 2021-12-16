package com.app.scooteroapp.activities

import android.app.DatePickerDialog
import android.content.Intent
import android.icu.text.DateFormatSymbols
import android.icu.util.Calendar
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.DatePicker
import androidx.annotation.RequiresApi
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityEditProfileBinding
import com.app.scooteroapp.entities.UpdateProfileRequest
import com.app.scooteroapp.fragments.GenderFragment
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class EditProfileActivity : AppCompatActivity() {
    lateinit var binding : ActivityEditProfileBinding
    var mYear = 0
    var mMonth = 0
    var mDay = 0
    var scProgressDialog = SCProgressDialog()

    @RequiresApi(Build.VERSION_CODES.N)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityEditProfileBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()

        binding.txtTitle.text = UiUtils.langValue(this,"GENERIC_PROFILE")
        binding.edtName.hint = UiUtils.langValue(this,"GENERIC_NAME")
        binding.edtDOB.hint = UiUtils.langValue(this,"GENERIC_DOB")
        binding.edtGender.hint = UiUtils.langValue(this,"GENERIC_GENDER")
        binding.edtEmail.hint = UiUtils.langValue(this,"GENERIC_EMAIL")
        binding.btnContinue.text = UiUtils.langValue(this,"GENERIC_CONTINUE")

        binding.edtName.setText(DevicePreferences.getSharedPreference(this,Constants.USER_NAME,SealedPreference.STRING) as String)
        val gender = DevicePreferences.getSharedPreference(this, Constants.USER_GENDER, SealedPreference.STRING) as String
        binding.edtDOB.setText(DevicePreferences.getSharedPreference(this, Constants.DOB, SealedPreference.STRING) as String)
        binding.edtGender.setText(if(gender == "1") "Male" else "Female")
        binding.edtEmail.setText(DevicePreferences.getSharedPreference(this,Constants.USER_EMAIL,SealedPreference.STRING) as String)
        binding.edtMobNo.setText(DevicePreferences.getSharedPreference(this,Constants.USER_MOB_NO,SealedPreference.STRING) as String)

        with(binding){
            imgBack.setOnClickListener { finish() }
            btnContinue.setOnClickListener {
                if(edtName.text.toString().isEmpty()){
                    UiUtils.showToast(this@EditProfileActivity,"Enter name")
                }else if(edtDOB.text.toString().isEmpty()){
                    UiUtils.showToast(this@EditProfileActivity,"Select Date of Birth")
                }else if(edtGender.text.toString().isEmpty()){
                    UiUtils.showToast(this@EditProfileActivity,"Select gender")
                }
                /*else if(edtEmail.text.toString().isEmpty()){
                    UiUtils.showToast(this@EditProfileActivity,"Enter email address")
                }else if(!CommonUtils.isValidEmail(edtEmail.text.toString())){
                    UiUtils.showToast(this@EditProfileActivity,"Enter valid email address")
                }*/
                else{
                    var updateProfileRequest = UpdateProfileRequest()
                    updateProfileRequest.id = DevicePreferences.getSharedPreference(this@EditProfileActivity,Constants.USER_ID,SealedPreference.STRING) as String
                    updateProfileRequest.dob = edtDOB.text.toString()
                    updateProfileRequest.email = edtEmail.text.toString()
                    updateProfileRequest.gender = edtGender.text.toString()
                    updateProfileRequest.name = edtName.text.toString()
                    scProgressDialog.showDialog(this@EditProfileActivity,"Updating profile details...")
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            val response = ApiCall.updateProfile(updateProfileRequest)
                            if(response.isSuccessful){
                                if(response.body()?.status == "Success"){
                                    withContext(Dispatchers.Main){
                                        scProgressDialog.dismissDialog()
                                        DevicePreferences.setSharedPreference(this@EditProfileActivity,Constants.USER_EMAIL,edtEmail.text.toString())
                                        DevicePreferences.setSharedPreference(this@EditProfileActivity,Constants.USER_GENDER,edtGender.text.toString())
                                        DevicePreferences.setSharedPreference(this@EditProfileActivity,Constants.DOB,edtDOB.text.toString())
                                        DevicePreferences.setSharedPreference(this@EditProfileActivity,Constants.USER_NAME,edtName.text.toString())
                                        Intent(this@EditProfileActivity,AcknowledgementActivity::class.java).apply {
                                            putExtra(Constants.ACK_TYPE,Constants.ACK_UPDATE_PROFILE)
                                        }.also {
                                            startActivity(it)
                                            finish()
                                        }
                                    }
                                }else{
                                    withContext(Dispatchers.Main){
                                        scProgressDialog.dismissDialog()
                                        UiUtils.showToast(this@EditProfileActivity,response.body()?.message.toString())
                                    }
                                }
                            }else{
                                withContext(Dispatchers.Main){
                                    scProgressDialog.dismissDialog()
                                    UiUtils.showToast(this@EditProfileActivity,"Unable to update profile details")
                                }
                            }
                        }catch (e:Exception){
                            e.printStackTrace()
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@EditProfileActivity,"Unable to update profile details")
                            }
                        }

                    }
                }
            }

            edtDOB.setOnClickListener{
                val calendar = Calendar.getInstance()
                mYear = calendar.get(Calendar.YEAR)
                mMonth = calendar.get(Calendar.MONTH)
                mDay = calendar.get(Calendar.DAY_OF_MONTH)
                val datePickerDialog = DatePickerDialog(this@EditProfileActivity,object: DatePickerDialog.OnDateSetListener{
                    override fun onDateSet(p0: DatePicker?, year: Int, month: Int, day: Int) {
                        edtDOB.setText("$day ${DateFormatSymbols().shortMonths[month]} $year")
                    }
                },mYear,mMonth,mDay)
                datePickerDialog.show()
            }
            edtGender.setOnClickListener {
                val genderFragment = GenderFragment{value,dialog->
                    edtGender.setText(value)
                    dialog.dismiss()
                }
                genderFragment.show(supportFragmentManager,"gender")
            }
        }
    }
}