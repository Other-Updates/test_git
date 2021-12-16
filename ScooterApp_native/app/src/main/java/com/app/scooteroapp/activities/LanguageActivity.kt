package com.app.scooteroapp.activities

import android.app.Activity
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityLanguageBinding
import com.app.scooteroapp.entities.LanguageRequest
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class LanguageActivity : AppCompatActivity() {

    lateinit var binding : ActivityLanguageBinding
    private var scProgressDialog = SCProgressDialog()
    var isFrom = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityLanguageBinding.inflate(layoutInflater)
        setContentView(binding.root)

        if(intent.extras?.containsKey("from") == true){
            isFrom = true
            if(DevicePreferences.getSharedPreference(this,Constants.LANGUAGE,SealedPreference.STRING) as String == "ENGLISH"){
                binding.rdEnglish.isChecked = true
                binding.rdArabic.isChecked = false
            }else if(DevicePreferences.getSharedPreference(this,Constants.LANGUAGE,SealedPreference.STRING) as String == "ARABIC"){
                binding.rdEnglish.isChecked = false
                binding.rdArabic.isChecked = true
            }
        }

        binding.txtEnglish.setOnClickListener {
            selectLang(true)
        }
        binding.rdEnglish.setOnCheckedChangeListener { compoundButton, b ->
            if(b)
                selectLang(b)
        }
        binding.txtArabic.setOnClickListener {
               selectLang(false)
        }
        binding.rdArabic.setOnCheckedChangeListener { compoundButton, b ->
            if(b)
                selectLang(false)
        }
    }

    private fun selectLang(isEnglish:Boolean){
        binding.rdEnglish.isChecked = isEnglish
        binding.rdArabic.isChecked = !isEnglish
        val languageRequest = LanguageRequest()
        if(isEnglish){
            DevicePreferences.setSharedPreference(this,Constants.LANGUAGE,"ENGLISH")
            languageRequest.language = "en"
        }else{
            DevicePreferences.setSharedPreference(this,Constants.LANGUAGE,"ARABIC")
            languageRequest.language = "ar"
        }
        scProgressDialog.showDialog(this,"Fetching contents please wait")
        CoroutineScope(Dispatchers.IO).launch {
            val response = ApiCall.languageContents(languageRequest)
            if(response.isSuccessful){
                if(response.body()?.status?.toLowerCase() == "success"){
                    DevicePreferences.setSharedPreference(this@LanguageActivity,Constants.LANG_CONTENT,response.body()?.data.toString())
                    withContext(Dispatchers.Main) {
                        scProgressDialog.dismissDialog()
                        if(isFrom){
                            val intent = Intent()
                            setResult(Activity.RESULT_OK,intent)
                            finish()
                        }else{
                            Intent(this@LanguageActivity,TutorialActivity::class.java).also {
                                startActivity(it)
                                finish()
                            }
                        }
                    }
                }else{
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@LanguageActivity,response.body()?.message.toString())
                    }
                }
            }else{
                withContext(Dispatchers.Main){
                    scProgressDialog.dismissDialog()
                    UiUtils.showToast(this@LanguageActivity,"Error fetching language details")
                }
            }
        }
    }
}


//  AIzaSyBnxC-LAyBEDC3F4EZ7xs_4f5Pgr15WU68
