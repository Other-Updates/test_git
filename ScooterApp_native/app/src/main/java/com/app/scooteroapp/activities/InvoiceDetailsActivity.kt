package com.app.scooteroapp.activities

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityInvoiceDetailsBinding
import com.app.scooteroapp.entities.InvoiceDetailRequest
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class InvoiceDetailsActivity : AppCompatActivity() {
    lateinit var binding : ActivityInvoiceDetailsBinding
    private var tripId : String? =""
    private val scProgressDialog = SCProgressDialog()
    lateinit var activityContext: Context

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityInvoiceDetailsBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()
        activityContext = this
        tripId = intent.extras?.getString("tripId")

        with(binding){
            txtHeader.text = UiUtils.langValue(activityContext,"GENERIC_INVOICE_DETAILS")
            txtTitle.text = UiUtils.langValue(activityContext,"GENERIC_RIDE_DETAILS")
            txtTripNoLabel.text = UiUtils.langValue(activityContext,"GENERIC_TRIP_NUMBER")
            txtScooterNoLabel.text = UiUtils.langValue(activityContext,"GENERIC_SCOO_SNO")
            txtStartTime.text = UiUtils.langValue(activityContext,"GENERIC_START_TIME")
            txtEndTimeValue.text = UiUtils.langValue(activityContext,"GENERIC_END_TIME")
            txtUnlock.text = UiUtils.langValue(activityContext,"GENERIC_UNLOCK_CHARGE")
            txtSubTotal.text = UiUtils.langValue(activityContext,"GENERIC_SUB_TOTAL")
            txtVat.text = UiUtils.langValue(activityContext,"GENERIC_VAT")
            txtGrandTotal.text = UiUtils.langValue(activityContext,"GENERIC_GRAND_TOTAL")
       //     btnContinue.text = UiUtils.langValue(activityContext,"GENERIC_SHARE_INVOICE")
            txtReport.text = UiUtils.langValue(activityContext,"GENERIC_REPORT_ISSUE_MSG")
        }
        scProgressDialog.showDialog(this,"Fetching invoice details")
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val invoiceDetailReq = InvoiceDetailRequest().apply {
                    id = DevicePreferences.getSharedPreference(this@InvoiceDetailsActivity,Constants.USER_ID,SealedPreference.STRING) as String
                    trip_id = tripId?:""
                }
                val response = ApiCall.invoiceDetails(invoiceDetailReq)
                if(response.isSuccessful){
                    withContext(Dispatchers.Main){
                        if(response.body()?.status == "Success"){
                            scProgressDialog.dismissDialog()
                            val invoiceDetail = response.body()?.data
                            invoiceDetail?.let {
                                with(binding){
                                    txtTripNo.text = invoiceDetail.trip_number
                                    txtScooterNo.text = invoiceDetail.scootoro_number
                                    txtStartTimeValue.text = invoiceDetail.start_time
                                    txtEndTimeValue.text = invoiceDetail.end_time
                                    txtRideDistanceValue.text = invoiceDetail.ride_distance + "km"
                                    txtRideTimeLabel.text = "${UiUtils.langValue(activityContext,"GENERIC_TOTAL_RIDE_TIME")}- ${invoiceDetail.total_ride_time}"
                                    txtRideRentValue.text = invoiceDetail.total_ride_amt + "SAR"
                                    txtUnlockChargeValue.text = invoiceDetail.unlock_charge + "SAR"
                                    txtSubTotalValue.text = invoiceDetail.sub_total + "SAR"
                                    txtVatValue.text = invoiceDetail.vat_charge + "SAR"
                                    txtGrandTotalValue.text = invoiceDetail.grand_total + "SAR"
                                }
                            }
                        }else{
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@InvoiceDetailsActivity,response.body()?.message.toString())
                        }
                    }
                }else{
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@InvoiceDetailsActivity,"Unable to fetch invoice details")
                    }
                }
            }catch (e:Exception){
                e.printStackTrace()
                withContext(Dispatchers.Main){
                    scProgressDialog.dismissDialog()
                    UiUtils.showToast(this@InvoiceDetailsActivity,"Unable to fetch invoice details")
                }
            }
        }

        binding.imgBack.setOnClickListener { finish() }
        binding.txtReport.setOnClickListener {
            Intent(this,ContactSupportActivity::class.java).also {
                startActivity(it)
            }
        }
    }

}