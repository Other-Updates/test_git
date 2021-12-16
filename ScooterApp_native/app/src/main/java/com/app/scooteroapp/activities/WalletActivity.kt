package com.app.scooteroapp.activities

import android.app.Activity
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.scooteroapp.adapters.WalletAdapter
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityWalletBinding
import com.app.scooteroapp.entities.AddWalletRequest
import com.app.scooteroapp.entities.DashboardRequest
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.payment.PayActivity
import com.app.scooteroapp.payment.PaymentConstants
import com.app.scooteroapp.room.LocalDatabase
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class WalletActivity : AppCompatActivity() {
    lateinit var binding : ActivityWalletBinding
    private val scProgressDialog = SCProgressDialog()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityWalletBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()

        binding.txtTitle.text = UiUtils.langValue(this,"GENERIC_WALLET")
        binding.txtAvailBalance.text = UiUtils.langValue(this,"GENERIC_AVAILABLE_BAL")
        binding.txtTypeLabel.text = UiUtils.langValue(this,"GENERIC_TYPE")
        binding.txtAmountLabel.text = UiUtils.langValue(this,"GENERIC_AMOUNT")
        binding.txtSourceLabel.text = UiUtils.langValue(this,"GENERIC_SOURCE")
        binding.txtCardLabel.text = UiUtils.langValue(this,"GENERIC_CODE")
        binding.txtDateLabel.text = UiUtils.langValue(this,"GENERIC_DATE")
        binding.txtTxnNoLabel.text = UiUtils.langValue(this,"GENERIC_TXN_NO")

        binding.txtAmount.text = DevicePreferences.getSharedPreference(this,Constants.WALLET_AMOUNT,SealedPreference.STRING) as String
        binding.rclWallet.layoutManager = LinearLayoutManager(this)

        binding.imgBack.setOnClickListener {
            finish()
        }

        binding.imgAdd.setOnClickListener {
            binding.imgAlpha.visibility = View.VISIBLE
            binding.crdAddWallet.visibility = View.VISIBLE
        }

        binding.imgWalletClose.setOnClickListener {
            binding.imgAlpha.visibility = View.GONE
            binding.crdAddWallet.visibility = View.GONE
        }

        binding.btnAddToWallet.setOnClickListener {
            if(binding.edtAmount.text.isNotEmpty()){
                binding.imgAlpha.visibility = View.GONE
                binding.crdAddWallet.visibility = View.GONE

                val paymentMethod = DevicePreferences.getSharedPreference(this,Constants.PAYMENT_METHOD,SealedPreference.STRING) as String
                if(paymentMethod.isEmpty()){
                    Intent(this,PaymentMethodActivity::class.java).
                    apply { putExtra("ScooterId","Wallet") }.also { startActivity(it) }
                }else if(paymentMethod == Constants.PAYMENT_CREDIT){
                    var localDatabase = LocalDatabase.getAppDatabase(this)
                    var card = localDatabase?.appDao()?.getCreditCard("Credit")

                    PaymentConstants.CARD_TYPE = "Credit"

                    startActivityForResult(Intent(this, PayActivity::class.java).apply {
                        putExtra("cardHolder",card?.name)
                        putExtra("cardNumber",card?.number)
                        putExtra("expiryMonth",card?.month)
                        putExtra("expiryYear",card?.year)
                        putExtra("cvv",card?.cvv)
                        putExtra("total",binding.edtAmount.text.toString())
                        putExtra("ScooterId","Wallet")
                    },1072)
                }else if(paymentMethod == Constants.PAYMENT_DEBIT){
                    val debitCard = DevicePreferences.getSharedPreference(this,Constants.PAYMENT_METHOD,SealedPreference.STRING) as String
                    if(debitCard.isEmpty()){
                        Intent(this,DebitCardActivity::class.java).apply {
                            putExtra("grandTotal",binding.edtAmount.text.toString())
                            putExtra("ScooterId","Wallet")
                        }.also { startActivityForResult(it,1070) }
                    }else{
                        Intent(this,RechargeOptionsActivity::class.java).apply {
                            putExtra("grandTotal",binding.edtAmount.text.toString())
                            putExtra("ScooterId","Wallet")
                        }.also { startActivityForResult(it,1071) }
                    }
                }

            }else{
                UiUtils.showToast(this,"Enter amount to add to wallet")
            }
        }

        loadWallet()
    }

    private fun loadWallet(){
        binding.txtEmpty.visibility = View.VISIBLE
        binding.txtEmpty.text = "Please wait while fetching wallet details"

        binding.edtAmount.setText("")
        scProgressDialog.showDialog(this,"Fetching wallet details")
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val req = DashboardRequest(DevicePreferences.getSharedPreference(this@WalletActivity,Constants.USER_ID,SealedPreference.STRING) as String)
                val response = ApiCall.customerWallet(req)
                if(response.isSuccessful){
                    val walletDet = response.body()
                    if(walletDet?.status == "Success"){
                        withContext(Dispatchers.Main){
                            val adapter = WalletAdapter(walletDet.data[0].walletDetails)
                            binding.rclWallet.adapter = adapter
                            scProgressDialog.dismissDialog()
                            if(walletDet.data.isEmpty()){
                                binding.txtEmpty.visibility = View.VISIBLE
                                binding.txtEmpty.text = "No wallet details found"
                            }else{
                                binding.txtEmpty.visibility = View.GONE
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@WalletActivity,response.body()?.message.toString())
                            binding.txtEmpty.visibility = View.VISIBLE
                            binding.txtEmpty.text = "No wallet details found"
                        }
                    }
                }else{
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@WalletActivity,"Unable to get wallet details")
                        binding.txtEmpty.visibility = View.VISIBLE
                        binding.txtEmpty.text = "No wallet details found"
                    }
                }
            }catch (e:Exception){
                e.printStackTrace()
                withContext(Dispatchers.Main){
                    scProgressDialog.dismissDialog()
                    UiUtils.showToast(this@WalletActivity,"Unable to get wallet details")
                    binding.txtEmpty.visibility = View.VISIBLE
                    binding.txtEmpty.text = "No wallet details found"
                }
            }
        }
    }

    private fun getDashboardDetails(){
        val dashboardReq = DashboardRequest(DevicePreferences.getSharedPreference(this,Constants.USER_ID,SealedPreference.STRING) as String)
        CoroutineScope(Dispatchers.IO).launch {
            val response = ApiCall.dashboardDet(dashboardReq)
            if(response.isSuccessful){
                if(response.body()?.status?.toLowerCase() == "success"){
                    withContext(Dispatchers.Main){
                        DevicePreferences.setSharedPreference(this@WalletActivity,Constants.WALLET_AMOUNT,response.body()?.data?.wallet_amount)
                        binding.txtAmount.text = DevicePreferences.getSharedPreference(this@WalletActivity,Constants.WALLET_AMOUNT,SealedPreference.STRING) as String
                    }
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(resultCode == Activity.RESULT_OK){
            scProgressDialog.showDialog(this,"Adding amount to wallet")
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val request = AddWalletRequest(DevicePreferences.getSharedPreference(this@WalletActivity,Constants.USER_ID,SealedPreference.STRING) as String,binding.edtAmount.text.toString())
                    val response = ApiCall.addToWallet(request)
                    if(response.isSuccessful){
                        if(response.body()?.status == "Success"){
                            withContext(Dispatchers.Main){
                                binding.imgAlpha.visibility = View.GONE
                                binding.crdAddWallet.visibility = View.GONE
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@WalletActivity,response.body()?.message.toString())
                                loadWallet()
                                getDashboardDetails();
                            }
                        }else{
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@WalletActivity,response.body()?.message.toString())
                                binding.txtEmpty.visibility = View.VISIBLE
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@WalletActivity,response.body()?.message.toString())
                            binding.txtEmpty.visibility = View.VISIBLE
                        }
                    }
                }catch (e:Exception){
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@WalletActivity,"Unable to add amount to wallet")
                    }
                }
            }
        }
    }
}