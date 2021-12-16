package com.app.scooteroapp.activities

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.LocationManager
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.core.app.ActivityCompat
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityManualBarcodeBinding
import com.app.scooteroapp.entities.CreditCardPaymentRequest
import com.app.scooteroapp.entities.UnlockScooterRequest
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.fragments.ScanResultFragment
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.payment.PayActivity
import com.app.scooteroapp.payment.PaymentConstants
import com.app.scooteroapp.room.LocalDatabase
import com.app.scooteroapp.room.TripEntity
import com.app.scooteroapp.utility.SimpleLocation
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class ManualBarcodeActivity : AppCompatActivity() {
    lateinit var binding : ActivityManualBarcodeBinding
    private var scProgressDialog = SCProgressDialog()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityManualBarcodeBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()

        with(binding){
            binding.txtTitle.text = UiUtils.langValue(this@ManualBarcodeActivity,"GENERIC_ENTER_QR")
            binding.edtBarcode.hint = UiUtils.langValue(this@ManualBarcodeActivity,"GENERIC_ENTER_QR_CODE")
            binding.txtUnlock.text = UiUtils.langValue(this@ManualBarcodeActivity,"GENERIC_UNLOCK_SCOOTER")
            imgBack.setOnClickListener { finish() }
            imgWallet.setOnClickListener {  }
            rlUnlockScooter.setOnClickListener {
                if(edtBarcode.text.toString().isEmpty()){
                    UiUtils.showToast(this@ManualBarcodeActivity,"Enter barcode")
                }else{
                    /*val scanResult = ScanResultFragment(UnlockScooterResponse.UnlockScooterDetail("01","01")).newInstance(
                        UnlockScooterResponse.UnlockScooterDetail("01","01"))
                    scanResult.setScanActivity(this@ManualBarcodeActivity)
                    scanResult.show(supportFragmentManager,"scanResult")*/

                    val unlockScooterRequest = UnlockScooterRequest().apply {
                        id = DevicePreferences.getSharedPreference(this@ManualBarcodeActivity,
                            Constants.USER_ID,
                            SealedPreference.STRING) as String
                        qr_code = edtBarcode.text.toString()
                        customer_id = id
                    }
                    val manager =   getSystemService(Context.LOCATION_SERVICE) as LocationManager

                    if (ActivityCompat.checkSelfPermission(this@ManualBarcodeActivity,
                            Manifest.permission.ACCESS_FINE_LOCATION) === PackageManager.PERMISSION_GRANTED &&
                        ActivityCompat.checkSelfPermission(this@ManualBarcodeActivity,
                            Manifest.permission.ACCESS_COARSE_LOCATION) === PackageManager.PERMISSION_GRANTED){

                        if (manager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                            val simpleLocation = SimpleLocation(this@ManualBarcodeActivity)
                            simpleLocation.beginUpdates()
                            unlockScooterRequest.scoo_lat = simpleLocation.latitude.toString()
                            unlockScooterRequest.scoo_long = simpleLocation.longitude.toString()
                        }
                    }
                    scProgressDialog.showDialog(this@ManualBarcodeActivity,"Getting scooter details")
                    CoroutineScope(Dispatchers.IO).launch {
                        try{
                            val response = ApiCall.unlockScooter(unlockScooterRequest)
                            if(response.isSuccessful){
                                if(response.body()?.status == "Success"){
                                    scProgressDialog.dismissDialog()
                                    val scanResult = ScanResultFragment(response.body()?.scootoro_details).newInstance(response.body()?.scootoro_details)
                                    scanResult.setScanActivity(this@ManualBarcodeActivity)
                                    scanResult.show(supportFragmentManager,"scanResult");
                                }else{
                                    withContext(Dispatchers.Main){
                                        scProgressDialog.dismissDialog()
                                        UiUtils.showToast(this@ManualBarcodeActivity,response.body()?.message.toString())
                                    }
                                }
                            }else{
                                withContext(Dispatchers.Main){
                                    scProgressDialog.dismissDialog()
                                    UiUtils.showToast(this@ManualBarcodeActivity,"Unable to get scooter detail")
                                }
                            }
                        }catch (e:Exception){
                            e.printStackTrace()
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@ManualBarcodeActivity,"Unable to get scooter detail")
                            }
                        }
                    }
                }
            }
        }
    }

    fun onCreditCardUnlock(){
        var localDatabase = LocalDatabase.getAppDatabase(this@ManualBarcodeActivity)
        var card = localDatabase?.appDao()?.getCreditCard("Credit")

        PaymentConstants.CARD_TYPE = "Credit"

        startActivityForResult(Intent(this, PayActivity::class.java).apply {
            putExtra("cardHolder",card?.name)
            putExtra("cardNumber",card?.number)
            putExtra("expiryMonth",card?.month)
            putExtra("expiryYear",card?.year)
            putExtra("cvv",card?.cvv)
            putExtra("total","20")
        },1012)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(requestCode == 1012 && resultCode == Activity.RESULT_OK){
            var localDatabase = LocalDatabase.getAppDatabase(this@ManualBarcodeActivity)
            var card = localDatabase?.appDao()?.getCreditCard("Credit")

            val creditCardPaymentRequest = CreditCardPaymentRequest().apply {
                id = DevicePreferences.getSharedPreference(this@ManualBarcodeActivity,Constants.USER_ID,SealedPreference.STRING) as String
                card_holder_name = card?.name?:""
                card_number = card?.number?:""
                expire_month = card?.month?:""
                expire_year = card?.year?.takeLast(2)?:""
                scootoro_id = "1"
                payment_method = "credit"
                cvv = card?.cvv?:""
                amount = "100"
            }
            scProgressDialog.showDialog(this@ManualBarcodeActivity,"Payment in process")
            CoroutineScope(Dispatchers.IO).launch{
                try {
                    val response = ApiCall.creditCardPayment(creditCardPaymentRequest)
                    if(response.isSuccessful){
                        val tripDetail = response.body()?.trip_details
                        if(response.body()?.status == "Success"){
                            var localDatabase = LocalDatabase.getAppDatabase(this@ManualBarcodeActivity)
                            var tripEntity = TripEntity().apply {
                                tripDetail?.let {
                                    tripNo = it.trip_number
                                    customerId = it.customer_id
                                    scooterId = it.scooter_id
                                    paymentId = it.payment_id
                                    rideStart = it.ride_start
                                    tripPaymentType = "Credit"
                                    isRideEnd = false
                                }
                            }
                            localDatabase?.appDao()?.newTrip(tripEntity)

                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                Intent(this@ManualBarcodeActivity,RidePostPaidActivity::class.java).also {
                                    startActivity(it)
                                }
                            }
                        }else{
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@ManualBarcodeActivity,response.body()?.message.toString())
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@ManualBarcodeActivity,"Unable to make payment")
                        }
                    }
                }catch (e:Exception){
                    e.printStackTrace()
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@ManualBarcodeActivity,"Unable to make payment")
                    }
                }
            }
        }else{
            try{
                val message = data?.extras?.getString("statusMessage");
                UiUtils.showToast(this,message?:"Payment unsuccessful")
            }catch (e:Exception){
                e.printStackTrace()
            }
        }
    }
}