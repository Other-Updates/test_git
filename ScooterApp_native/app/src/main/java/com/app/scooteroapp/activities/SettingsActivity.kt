package com.app.scooteroapp.activities

import android.app.Activity
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.app.scooteroapp.databinding.ActivitySettingsBinding
import com.app.scooteroapp.utility.UiUtils

class SettingsActivity : AppCompatActivity() {
    lateinit var binding : ActivitySettingsBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySettingsBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()
        binding.txtTitle.text = UiUtils.langValue(this,"GENERIC_SETTINGS")
        binding.txtChangeNo.text = UiUtils.langValue(this,"GENERIC_CHANGE_MOBILE_NUMBER")
        binding.txtChangeMail.text = UiUtils.langValue(this,"GENERIC_CHANGE_EMAIL_ID")
        binding.txtChangePass.text = UiUtils.langValue(this,"GENERIC_CHANGE_PASSWORD")
        binding.txtChangeLang.text = UiUtils.langValue(this,"GENERIC_CHOOSE_LANGUGAE")

        binding.imgBack.setOnClickListener { finish() }
        binding.txtChangeNo.setOnClickListener {
            Intent(this,ChangeNumberActivity::class.java).also {
                startActivity(it)
            }
        }
        binding.txtChangeMail.setOnClickListener {
            Intent(this,ChangeEmailActivity::class.java).also {
                startActivity(it)
            }
        }
        binding.txtChangePass.setOnClickListener {
            Intent(this,ChangePasswordActivity::class.java).also {
                startActivity(it)
            }
        }
        binding.txtChangeLang.setOnClickListener {
            Intent(this,LanguageActivity::class.java).apply {
                putExtra("from","changeLang")
            }.also {
                startActivityForResult(it,1000)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(requestCode == 1000 && resultCode == Activity.RESULT_OK){
            binding.txtTitle.text = UiUtils.langValue(this,"GENERIC_SETTINGS")
            binding.txtChangeNo.text = UiUtils.langValue(this,"GENERIC_CHANGE_MOBILE_NUMBER")
            binding.txtChangeMail.text = UiUtils.langValue(this,"GENERIC_CHANGE_EMAIL_ID")
            binding.txtChangePass.text = UiUtils.langValue(this,"GENERIC_CHANGE_PASSWORD")
            binding.txtChangeLang.text = UiUtils.langValue(this,"GENERIC_CHOOSE_LANGUGAE")
        }
    }
}