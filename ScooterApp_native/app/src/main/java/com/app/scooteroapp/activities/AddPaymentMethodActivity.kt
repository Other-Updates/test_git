package com.app.scooteroapp.activities

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.app.scooteroapp.databinding.ActivityAddPaymentMethodBinding
import com.app.scooteroapp.utility.UiUtils

class AddPaymentMethodActivity : AppCompatActivity() {

    lateinit var binding : ActivityAddPaymentMethodBinding
    private var scooterId:String?=""
    lateinit var activityContext: Context

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityAddPaymentMethodBinding.inflate(layoutInflater)
        setContentView(binding.root)
        activityContext = this
        supportActionBar?.hide()
        with(binding){
            txtTitle.text = UiUtils.langValue(activityContext,"GENERIC_ADD_PAYMENT_METHOD")
            txtCreditCard.text = UiUtils.langValue(activityContext,"GENERIC_POST_PAID")
            txtDebitCard.text = UiUtils.langValue(activityContext,"GENERIC_PRE_PAID")
            txtWallet.text = UiUtils.langValue(activityContext,"GENERIC_SCOOTERO_WALLET")
            btnAddPaymentMethod.text = UiUtils.langValue(activityContext,"GENERIC_CONTINUE")
        }
        scooterId = intent.extras?.getString("ScooterId")
        initListeners()
    }

    private fun initListeners(){
        with(binding){
            imgBack.setOnClickListener { finish() }
            btnAddPaymentMethod.setOnClickListener {
                if(rdCreditCard.isChecked){
                    Intent(this@AddPaymentMethodActivity,AddCreditCardActivity::class.java).apply { putExtra("ScooterId",scooterId) }.also {
                        startActivity(it)
                    }
                }else if (rdDebitCard.isChecked){
                    Intent(this@AddPaymentMethodActivity,ChooseRiderPlanActivity::class.java).apply { putExtra("ScooterId",scooterId) }.also {
                        startActivity(it)
                    }
                }
            }

            crdCreditCard.setOnClickListener {
                rdCreditCard.isChecked = true
                rdDebitCard.isChecked = false
                rdWallet.isChecked = false
            }
            crdDebitCard.setOnClickListener {
                rdCreditCard.isChecked = false
                rdDebitCard.isChecked = true
                rdWallet.isChecked = false
            }
            crdWallet.setOnClickListener {
                rdCreditCard.isChecked = false
                rdDebitCard.isChecked = false
                rdWallet.isChecked = true
            }
        }
    }
}