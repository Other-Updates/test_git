package com.app.scooteroapp.activities

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.app.scooteroapp.databinding.ActivityRechargeBinding
import com.app.scooteroapp.utility.UiUtils

class RechargeActivity : AppCompatActivity() {
    lateinit var binding : ActivityRechargeBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityRechargeBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.txtHeader.text = UiUtils.langValue(this,"GENERIC_RECHARGE")
        binding.txtTitle.text = UiUtils.langValue(this,"GENERIC_CHOOSE_RIDE_TIME")

        binding.imgBack.setOnClickListener { finish() }
    }
}