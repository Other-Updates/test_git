package com.app.scooteroapp.activities

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Bundle
import android.os.Handler
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityScanBinding
import com.app.scooteroapp.entities.UnlockScooterRequest
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.fragments.ScanResultFragment
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.SimpleLocation
import com.app.scooteroapp.utility.UiUtils
import com.budiyev.android.codescanner.*
import com.google.zxing.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext


class ScanActivity : AppCompatActivity(){
    lateinit var binding : ActivityScanBinding
    private val scProgressDialog = SCProgressDialog()
    lateinit var mCodeScanner : CodeScanner

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityScanBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()
        binding.txtTitle.text = UiUtils.langValue(this,"GENERIC_SCAN_RIDE")
        binding.btnManualBarcode.text = UiUtils.langValue(this,"GENERIC_ENTER_QR")


        binding.imgBack.setOnClickListener {
            finish()
        }
        binding.imgWallet.setOnClickListener {
            Intent(this,WalletActivity::class.java).also { startActivity(it) }
        }
        binding.btnManualBarcode.setOnClickListener {
            Intent(this,ManualBarcodeActivity::class.java).also {
                startActivity(it)
                finish()
            }
        }

        if(ActivityCompat.checkSelfPermission(this,Manifest.permission.CAMERA) !== PackageManager.PERMISSION_GRANTED){
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CAMERA), 1250)
        }else{
            startScanning()
        }
    }

    private fun startScanning() {
        val scannerView = binding.scannerView
        if(!this::mCodeScanner.isInitialized){
            mCodeScanner = CodeScanner(this, scannerView)
        }
        mCodeScanner.autoFocusMode = AutoFocusMode.SAFE
        mCodeScanner.zoom = 0
        mCodeScanner.setDecodeCallback(object : DecodeCallback {
            override fun onDecoded(result: Result) {
                runOnUiThread {
                    scanResult(result.text)
                }
            }

        })
        Handler().postDelayed({
            mCodeScanner.startPreview()
        },500)
    }
    
    private fun scanResult(barcode:String){
        val unlockScooterRequest = UnlockScooterRequest().apply {
            id = DevicePreferences.getSharedPreference(this@ScanActivity,
                Constants.USER_ID,
                SealedPreference.STRING) as String
            qr_code = barcode
            customer_id = id
        }
        val manager =   getSystemService(Context.LOCATION_SERVICE) as LocationManager

        if (ActivityCompat.checkSelfPermission(this@ScanActivity,
                Manifest.permission.ACCESS_FINE_LOCATION) === PackageManager.PERMISSION_GRANTED &&
            ActivityCompat.checkSelfPermission(this@ScanActivity,
                Manifest.permission.ACCESS_COARSE_LOCATION) === PackageManager.PERMISSION_GRANTED){

            if (manager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                val simpleLocation = SimpleLocation(this@ScanActivity)
                simpleLocation.beginUpdates()
                unlockScooterRequest.scoo_lat = simpleLocation.latitude.toString()
                unlockScooterRequest.scoo_long = simpleLocation.longitude.toString()
            }
        }
        scProgressDialog.showDialog(this@ScanActivity,"Getting scooter details")
        CoroutineScope(Dispatchers.IO).launch {
            try{
                val response = ApiCall.unlockScooter(unlockScooterRequest)
                if(response.isSuccessful){
                    if(response.body()?.status == "Success"){
                        scProgressDialog.dismissDialog()
                        val scanResult = ScanResultFragment(response.body()?.scootoro_details).newInstance(response.body()?.scootoro_details)
                        scanResult.setScanActivity(this@ScanActivity)
                        scanResult.show(supportFragmentManager,"scanResult");
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@ScanActivity,response.body()?.message.toString())
                        }
                    }
                }else{
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@ScanActivity,"Unable to get scooter detail")
                    }
                }
            }catch (e:Exception){
                e.printStackTrace()
                withContext(Dispatchers.Main){
                    scProgressDialog.dismissDialog()
                    UiUtils.showToast(this@ScanActivity,"Unable to get scooter detail")
                }
            }
        }
    }
    /*fun onCreditCardUnlock(){
        var localDatabase = LocalDatabase.getAppDatabase(this@ScanActivity)
        val creditCardPaymentRequest = CreditCardPaymentRequest().apply {
            id = DevicePreferences.getSharedPreference(this@ScanActivity,Constants.USER_ID,SealedPreference.STRING) as String
            card_holder_name = binding.edtName.text.toString()
            card_number = "${binding.edtCardNo1.text.toString()}${binding.edtCardNo2.text.toString()}${binding.edtCardNo3.text.toString()}${binding.edtCardNo4.text.toString()}"
            expire_month = binding.edtMonth.text.toString()
            expire_year = "20${binding.edtYear.text.toString()}"
            scootoro_id = scooterId?:""
            payment_method = "credit"
            cvv = binding.edtCvv.text.toString()
            amount = "100"
        }
        scProgressDialog.showDialog(this@ScanActivity,"Payment in process")
        CoroutineScope(Dispatchers.IO).launch{
            try {
                val response = ApiCall.creditCardPayment(creditCardPaymentRequest)
                if(response.isSuccessful){
                    val tripDetail = response.body()?.trip_details
                    if(response.body()?.status == "Success"){
                        var localDatabase = LocalDatabase.getAppDatabase(this@ScanActivity)
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
                            Intent(this@ScanActivity,RidePostPaidActivity::class.java).also {
                                startActivity(it)
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@ScanActivity,response.body()?.message.toString())
                        }
                    }
                }else{
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@ScanActivity,"Unable to make payment")
                    }
                }
            }catch (e:Exception){
                e.printStackTrace()
                withContext(Dispatchers.Main){
                    scProgressDialog.dismissDialog()
                    UiUtils.showToast(this@ScanActivity,"Unable to make payment")
                }
            }
        }
    }*/

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if(requestCode == 1250){
            if(grantResults[0] == PackageManager.PERMISSION_GRANTED){
                startScanning()
            }
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }
}