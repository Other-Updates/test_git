package com.app.scooteroapp.activities

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.scooteroapp.adapters.InvoiceListAdapter
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityInvoiceListBinding
import com.app.scooteroapp.entities.GetScootersRequest
import com.app.scooteroapp.entities.InvoiceListResponse
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class InvoiceListActivity : AppCompatActivity() {
    lateinit var binding : ActivityInvoiceListBinding
    private val scProgressDialog = SCProgressDialog()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityInvoiceListBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()
        binding.rclInvoice.layoutManager = LinearLayoutManager(this)
        binding.txtTitle.text = UiUtils.langValue(this,"GENERIC_INVOICE")
        scProgressDialog.showDialog(this,"Fetching invoice details")
        binding.txtEmpty.visibility = View.VISIBLE
        binding.txtEmpty.text = "Please wait while fetching invoices"
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val invoiceListRequest = GetScootersRequest().apply{
                    id=DevicePreferences.getSharedPreference(this@InvoiceListActivity,Constants.USER_ID,SealedPreference.STRING) as String}
                val response = ApiCall.invoiceList(invoiceListRequest)
                if(response.isSuccessful){
                    if(response.body()?.status == "Success"){
                        var list = response.body()?.data
                        withContext(Dispatchers.Main) {
                            binding.txtEmpty.visibility = View.GONE
                            scProgressDialog.dismissDialog()
                            list?.let {
                                if(it.isEmpty()){
                                    binding.txtEmpty.visibility = View.VISIBLE
                                    binding.txtEmpty.text = "No Invoices available"
                                }else{
                                    val adapter = InvoiceListAdapter(list,this@InvoiceListActivity)
                                    binding.rclInvoice.adapter = adapter
                                }
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            binding.txtEmpty.visibility = View.VISIBLE
                            binding.txtEmpty.text = "No Invoices available"
                            UiUtils.showToast(this@InvoiceListActivity,response.body()?.message.toString())
                        }
                    }
                }else{
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        binding.txtEmpty.visibility = View.VISIBLE
                        binding.txtEmpty.text = "No Invoices available"
                        UiUtils.showToast(this@InvoiceListActivity,"Unable to get invoice details")
                    }
                }
            }catch (e:Exception){
                e.printStackTrace()
                withContext(Dispatchers.Main){
                    scProgressDialog.dismissDialog()
                    binding.txtEmpty.visibility = View.VISIBLE
                    binding.txtEmpty.text = "No Invoices available"
                    UiUtils.showToast(this@InvoiceListActivity,"Unable to get invoice details")
                }
            }
        }

        binding.imgBack.setOnClickListener { finish() }
    }

    fun onInvoiceSelect(invoice:InvoiceListResponse.Invoice){
        Intent(this,InvoiceDetailsActivity::class.java).apply {
            putExtra("tripId",invoice.id)
        }.also {
            startActivity(it)
        }
    }
}