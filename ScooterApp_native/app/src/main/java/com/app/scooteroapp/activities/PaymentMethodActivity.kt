package com.app.scooteroapp.activities

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.app.scooteroapp.databinding.ActivityPaymentMethodBinding
import com.app.scooteroapp.utility.UiUtils

class PaymentMethodActivity : AppCompatActivity() {
    lateinit var binding : ActivityPaymentMethodBinding
    private var scooterId:String? = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityPaymentMethodBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()
        binding.txtTitle.text = UiUtils.langValue(this,"GENERIC_PAYMENT_METHOD")
        binding.txtContent.text = UiUtils.langValue(this,"GENERIC_PAYMENT_METHOD_MSG")
        binding.btnAddPaymentMethod.text = UiUtils.langValue(this,"GENERIC_ADD_PAYMENT_METHOD")
        scooterId = intent.extras?.getString("ScooterId")
        initListeners()
    }

    private fun initListeners(){
        binding.imgBack.setOnClickListener {
            finish()
        }
        binding.imgWallet.setOnClickListener {

        }
        binding.btnAddPaymentMethod.setOnClickListener {
            Intent(this,AddPaymentMethodActivity::class.java).apply {
                putExtra("ScooterId",scooterId)
            }.also {
                startActivity(it)
                finish()
            }
        }
    }
}



