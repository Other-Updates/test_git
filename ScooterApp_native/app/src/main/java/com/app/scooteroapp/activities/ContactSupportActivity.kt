package com.app.scooteroapp.activities

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.app.scooteroapp.databinding.ActivityContactSupportBinding
import com.app.scooteroapp.utility.UiUtils

class ContactSupportActivity : AppCompatActivity() {
    lateinit var binding : ActivityContactSupportBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityContactSupportBinding.inflate(layoutInflater)
        setContentView(binding.root)

        with(binding){
            textView3.text = UiUtils.langValue(this@ContactSupportActivity,"GENERIC_CONTACT_SUPPORT_MSG_1")
            edtRemarks.hint = UiUtils.langValue(this@ContactSupportActivity,"GENERIC_CONTACT_SUPPORT_MSG_2")
            btnSubmit.text = UiUtils.langValue(this@ContactSupportActivity,"GENERIC_SUBMIT")
            btnSubmit.setOnClickListener {
                if(edtRemarks.text.toString().isEmpty()){
                    UiUtils.showToast(this@ContactSupportActivity,"Enter issue details")
                }else{
                    finish()
                }
            }
            btnClose.setOnClickListener { finish() }

        }
    }
}