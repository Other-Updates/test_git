package com.app.scooteroapp.activities

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.scooteroapp.R
import com.app.scooteroapp.adapters.CreditedDetailsAdapter
import com.app.scooteroapp.adapters.DebitedDetailsAdapter
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityPaymentsBinding
import com.app.scooteroapp.entities.CreditedDetailsRequest
import com.app.scooteroapp.entities.DebitedDetailsRequest
import com.app.scooteroapp.utility.UiUtils
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext



class PaymentsActivity : AppCompatActivity() {
    lateinit var binding : ActivityPaymentsBinding
    private val scProgressDialog = SCProgressDialog()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityPaymentsBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()

        binding.txtTitle.text = UiUtils.langValue(this,"GENERIC_PAYMENTS")
        binding.txtAvailBalance.text = UiUtils.langValue(this,"GENERIC_AVAILABLE_BAL")
        binding.btnCredited.text = UiUtils.langValue(this,"GENERIC_CREDITED")
        binding.btnDebited.text = UiUtils.langValue(this,"GENERIC_DEBITED")
        binding.txtType.text = UiUtils.langValue(this,"GENERIC_DEBIT")
        binding.txtAmountLabel.text = UiUtils.langValue(this,"GENERIC_AMOUNT")
        binding.txtSourceLabel.text = UiUtils.langValue(this,"GENERIC_SOURCE")
        binding.txtCardLabel.text = UiUtils.langValue(this,"GENERIC_CODE")
        binding.txtDateLabel.text = UiUtils.langValue(this,"GENERIC_DATE")
        binding.txtTxnNoLabel.text = UiUtils.langValue(this,"GENERIC_TXN_NO")


        binding.rclWallet.layoutManager = LinearLayoutManager(this)

        initListeners()


}

    private fun initListeners(){
        with(binding){
            imgBack.setOnClickListener { finish() }
            btnCredited.setOnClickListener {
                with(btnCredited){
                    background = resources.getDrawable(R.drawable.bg_segment_active,null)
                    setTextColor(getColor(R.color.white))
                    translationZ = 5F
                    loadCredited()
                }
                with(btnDebited){
                    background = resources.getDrawable(R.drawable.bg_segment_inactive,null)
                    setTextColor(getColor(R.color.gray))
                    translationZ = 0F
                }
            }
            btnDebited.setOnClickListener {
                with(btnDebited){
                    background = resources.getDrawable(R.drawable.bg_segment_active,null)
                    setTextColor(getColor(R.color.white))
                    translationZ = 5F
                    loadDebited()
                }
                with(btnCredited){
                    background = resources.getDrawable(R.drawable.bg_segment_inactive,null)
                    setTextColor(getColor(R.color.gray))
                    translationZ = 0F
                }
            }
        }
    }
    private fun loadCredited(){
        binding.txtType.visibility = View.VISIBLE
        binding.txtType.text = "Please wait while fetching Credited details"
        binding.txtDateLabel.setText("")

        binding.txtAmountValue.setText("")
        scProgressDialog.showDialog(this,"Fetching Credited details")
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val req = CreditedDetailsRequest(
                    DevicePreferences.getSharedPreference(this@PaymentsActivity,
                        Constants.USER_ID,
                        SealedPreference.STRING) as String)
                val response = ApiCall.creditedDetails(req)
                if(response.isSuccessful){
                    val creditDet = response.body()
                    if(creditDet?.status == "Success"){
                        withContext(Dispatchers.Main){
                            val adapter = CreditedDetailsAdapter(creditDet?.data)
                            binding.rclWallet.adapter = adapter
                            scProgressDialog.dismissDialog()
                            if(creditDet?.data.isEmpty()){
                                binding.txtType.visibility = View.VISIBLE
                                binding.txtType.text = "No credited details found"
                            }else{
                                binding.txtType.visibility = View.GONE
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@PaymentsActivity,response.body()?.message.toString())
                            binding.txtType.visibility = View.VISIBLE
                            binding.txtType.text = "No credited details found"
                        }
                    }
                }else{
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@PaymentsActivity,"Unable to get credited details")
                        binding.txtType.visibility = View.VISIBLE
                        binding.txtType.text = "No credited details found"
                    }
                }
            }catch (e:Exception){
                e.printStackTrace()
                withContext(Dispatchers.Main){
                    scProgressDialog.dismissDialog()
                    UiUtils.showToast(this@PaymentsActivity,"Unable to get credited details")
                    binding.txtType.visibility = View.VISIBLE
                    binding.txtType.text = "No credited details found"
                }
            }
        }
    }

    private fun loadDebited(){
        binding.txtType.visibility = View.VISIBLE
        binding.txtType.text = "Please wait while fetching Debited details"
        binding.txtDateLabel.setText("")
        binding.txtAmountValue.setText("")
        scProgressDialog.showDialog(this,"Fetching Debited details")
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val req = DebitedDetailsRequest(
                    DevicePreferences.getSharedPreference(this@PaymentsActivity,
                        Constants.USER_ID,
                        SealedPreference.STRING) as String)
                val response = ApiCall.debitedDetails(req)
                if(response.isSuccessful){
                    val debitDet = response.body()
                    if(debitDet?.status == "Success"){
                        withContext(Dispatchers.Main){
                            val adapter = DebitedDetailsAdapter(debitDet?.data)
                            binding.rclWallet.adapter = adapter
                            scProgressDialog.dismissDialog()
                            if(debitDet?.data.isEmpty()){
                                binding.txtType.visibility = View.VISIBLE
                                binding.txtType.text = "No debited details found"
                            }else{
                                binding.txtType.visibility = View.GONE
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@PaymentsActivity,response.body()?.message.toString())
                            binding.txtType.visibility = View.VISIBLE
                            binding.txtType.text = "No debited details found"
                        }
                    }
                }else{
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@PaymentsActivity,"Unable to get debited details")
                        binding.txtType.visibility = View.VISIBLE
                        binding.txtType.text = "No debited details found"
                    }
                }
            }catch (e:Exception){
                e.printStackTrace()
                withContext(Dispatchers.Main){
                    scProgressDialog.dismissDialog()
                    UiUtils.showToast(this@PaymentsActivity,"Unable to get debiteddetails")
                    binding.txtType.visibility = View.VISIBLE
                    binding.txtType.text = "No debited details found"
                }
            }
        }
    }



}


