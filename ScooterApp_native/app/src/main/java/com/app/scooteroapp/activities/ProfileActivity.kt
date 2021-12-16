package com.app.scooteroapp.activities

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityProfileBinding
import com.app.scooteroapp.utility.UiUtils

class ProfileActivity : AppCompatActivity() {

    lateinit var binding : ActivityProfileBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityProfileBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()

        binding.nameTitle.text = UiUtils.langValue(this,"GENERIC_NAME")
        binding.dobTitle.text = UiUtils.langValue(this,"GENERIC_DOB")
        binding.genderTitle.text = UiUtils.langValue(this,"GENERIC_GENDER")
        binding.mobNoTitle.text = UiUtils.langValue(this,"GENERIC_MOBILE_NUMBER")
        binding.emailTitle.text = UiUtils.langValue(this,"GENERIC_EMAIL_ID")
        binding.txtName.text = DevicePreferences.getSharedPreference(this, Constants.USER_NAME, SealedPreference.STRING) as String
        binding.txtDOB.text = DevicePreferences.getSharedPreference(this, Constants.DOB, SealedPreference.STRING) as String
        val gender = DevicePreferences.getSharedPreference(this, Constants.USER_GENDER, SealedPreference.STRING) as String
        binding.txtGender.text = if(gender == "1") "Male" else "Female"
        binding.txtEmail.text = DevicePreferences.getSharedPreference(this, Constants.USER_EMAIL, SealedPreference.STRING) as String
        binding.txtMobNo.text = DevicePreferences.getSharedPreference(this, Constants.USER_MOB_NO, SealedPreference.STRING) as String

        with(binding){
            imgBack.setOnClickListener { finish() }
            btnEdit.setOnClickListener {
                Intent(this@ProfileActivity,EditProfileActivity::class.java).also {
                    startActivity(it)
                }
            }
        }
    }
}