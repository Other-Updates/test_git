package com.app.scooteroapp.activities

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.location.Location
import android.location.LocationManager
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.util.Log
import android.view.View
import android.view.inputmethod.InputMethodManager
import androidx.core.app.ActivityCompat
import com.app.scooteroapp.R
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityRidePostPaidBinding
import com.app.scooteroapp.entities.EndRideRequest
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.room.LocalDatabase
import com.app.scooteroapp.room.TripDetailEntity
import com.app.scooteroapp.room.TripEntity
import com.app.scooteroapp.room.TripLocEntity
import com.app.scooteroapp.utility.CommonUtils
import com.app.scooteroapp.utility.SimpleLocation
import com.app.scooteroapp.utility.UiUtils
import com.budiyev.android.codescanner.AutoFocusMode
import com.budiyev.android.codescanner.CodeScanner
import com.budiyev.android.codescanner.DecodeCallback
import com.google.android.gms.common.api.GoogleApiClient
import com.google.android.gms.common.api.ResultCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.LocationSettingsRequest
import com.google.android.gms.location.LocationSettingsResult
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.*
import com.google.zxing.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList

class RidePostPaidActivity : AppCompatActivity(), OnMapReadyCallback, GoogleApiClient.ConnectionCallbacks {
    private lateinit var binding : ActivityRidePostPaidBinding
    private lateinit var mGoogleApiClient : GoogleApiClient
    private lateinit var mLastLocation : Location
    private lateinit var mLocationRequest: LocationRequest
    private var latitudeValue = 0.0
    private var longitudeValue = 0.0
    private var mMap : GoogleMap? = null
    private val scProgressDialog = SCProgressDialog()
    private var currentTrip : TripEntity? = TripEntity()
    private var localDatabase: LocalDatabase? = null
    private val simpleDateFormat = SimpleDateFormat("yyyy-MM-dd hh:mm:ss")
    var rideTimer = Timer()
    val addedLocs = ArrayList<LatLng>()
    var distances = ArrayList<Float>()
    lateinit var activityContext : Context
    lateinit var mCodeScanner : CodeScanner

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityRidePostPaidBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()
        activityContext = this

        localDatabase = LocalDatabase.getAppDatabase(this)
        currentTrip = localDatabase?.appDao()?.openTrip()
        initTimer()

        with(binding){
            txtTitle.text = UiUtils.langValue(activityContext,"GENERIC_SCOOTERO_RIDE")
            txtRidingTime.text = UiUtils.langValue(activityContext,"GENERIC_RIDING_TIME")
            txtRideRange.text = UiUtils.langValue(activityContext,"GENERIC_RIDING_RANGE")
            txtDistance.text = UiUtils.langValue(activityContext,"GENERIC_DISTANCE")
            btnEndRide.text = UiUtils.langValue(activityContext,"GENERIC_END_RIDE")
            txtParkScooterSafe.text = UiUtils.langValue(activityContext,"GENERIC_PARK_SCOOTER_SAFE")
            txtParkScooterComment.text = UiUtils.langValue(activityContext,"GENERIC_PARK_SCOOTER_SAFE_MSG")
            btnOKay.text = UiUtils.langValue(activityContext,"GENERIC_OK")
        }

//        mGoogleApiClient = GoogleApiClient.Builder(this).addConnectionCallbacks(this).addApi(LocationServices.API).build()
//        mLocationRequest = createLocationRequest()
        val mapFragment = supportFragmentManager
            .findFragmentById(R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)

        binding.btnOKay.setOnClickListener {
            Intent(this@RidePostPaidActivity,RideRentPostActivity::class.java).apply {
                putExtra("tripId",currentTrip?.id.toString())
            }.also {
                startActivity(it)
                finish()
            }
        }

        binding.btnEndRide.setOnClickListener {
            binding.btnEndRide.visibility = View.GONE
            binding.scannerView.visibility = View.VISIBLE
            binding.btnManualBarcode.visibility = View.VISIBLE

            if(ActivityCompat.checkSelfPermission(this,Manifest.permission.CAMERA) !== PackageManager.PERMISSION_GRANTED){
                ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CAMERA), 1250)
            }else{
                startScanning()
            }
        }

        binding.btnManualBarcode.setOnClickListener {
            binding.btnEndRide.visibility = View.GONE
            binding.scannerView.visibility = View.GONE
            binding.btnManualBarcode.visibility = View.GONE
            mCodeScanner.stopPreview()
            binding.clManualBarcode.visibility = View.VISIBLE
        }

        binding.btnQrEndRide.setOnClickListener {
            if(binding.edtBarcode.text.isEmpty()){
                UiUtils.showToast(this,"Please enter barcode...")
            }else if(binding.edtBarcode.text.length < 6){
                UiUtils.showToast(this,"Please enter valid barcode...")
            }else{
                try {
                    val im = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
                    im.hideSoftInputFromWindow(it.windowToken,0)
                }catch (e:Exception){
                    e.printStackTrace()
                }
                endRideFn()
            }
        }

        binding.imgBack.setOnClickListener {
            if(binding.clManualBarcode.visibility == View.VISIBLE){
                binding.clManualBarcode.visibility = View.GONE
                binding.btnEndRide.visibility = View.VISIBLE
            }else if(binding.scannerView.visibility == View.VISIBLE){
                binding.scannerView.visibility = View.GONE
                binding.btnManualBarcode.visibility = View.GONE
                binding.btnEndRide.visibility = View.VISIBLE
            }else{
                finish()
            }
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
                    endRideFn()
                }
            }

        })
        Handler().postDelayed({
            mCodeScanner.startPreview()
        },500)
    }

    private fun endRideFn(){
        val manager =   this.getSystemService(Context.LOCATION_SERVICE) as LocationManager

        if (ActivityCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_FINE_LOCATION) === PackageManager.PERMISSION_GRANTED &&
            ActivityCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_COARSE_LOCATION) === PackageManager.PERMISSION_GRANTED){

            if (manager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                val simpleLocation = SimpleLocation(this)
                simpleLocation.beginUpdates()
                endRide(simpleLocation.latitude.toString(),simpleLocation.longitude.toString())
            }
        }else{
            ActivityCompat.requestPermissions(this,
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION,Manifest.permission.ACCESS_COARSE_LOCATION),
                200)
        }
    }

    private fun endRide(lat:String,lng:String){
        rideTimer.cancel()
        scProgressDialog.showDialog(this,"Ending ride")
        currentTrip?.isRideEnd = true
        localDatabase?.appDao()?.updateTrip(currentTrip)

        val endRideRequest = EndRideRequest().apply {
            id = DevicePreferences.getSharedPreference(this@RidePostPaidActivity,Constants.USER_ID,SealedPreference.STRING) as String
            scootoro_id = currentTrip?.scooterId?:""
            trip_number = currentTrip?.tripNo?:""
            distance = binding.txtDistanceValue.text.toString().replace("m","").replace("k","")
            customer_id = id
            scoo_lat = lat
            scoo_long = lng

        }

        CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = ApiCall.endRide(endRideRequest)
                if(response.isSuccessful){
                    if(response.body()?.status == "Success"){
                        val rideEndEntity = response.body()?.trip_details
                        rideEndEntity?.let {
                            val tripDetailEntity = TripDetailEntity().apply {
                                tripId= currentTrip?.id?:0
                                tripNumber=rideEndEntity.trip_number
                                subscriptionId=rideEndEntity.subscription_id
                                rideEnd=rideEndEntity.ride_end
                                rideDistance=rideEndEntity.ride_distance
                                rideMins= rideEndEntity.ride_mins?:"0"
                                totalRideAmt=rideEndEntity.total_ride_amt
                                unlockCharge=rideEndEntity.unlock_charge
                                subTotal=rideEndEntity.sub_total
                                vatCharge=rideEndEntity.vat_charge
                                grandTotal=rideEndEntity.grand_total
                                status=rideEndEntity.status
                                customerId =rideEndEntity.customer_id
                                scooterId=rideEndEntity.scooter_id
                                paymentId=rideEndEntity.payment_id
                                rideStart=rideEndEntity.ride_start
                                serverTripId = rideEndEntity.id
                            }
                            localDatabase?.appDao()?.newTripDetail(tripDetailEntity)
                        }
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            binding.clManualBarcode.visibility = View.GONE
                            binding.scannerView.visibility = View.GONE
                            binding.btnManualBarcode.visibility = View.GONE
                            mCodeScanner.stopPreview()
                            binding.rlDialog.visibility = View.VISIBLE
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                        }
                    }
                }else{
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                    }
                }
            }catch (e:Exception){
                e.printStackTrace()
                withContext(Dispatchers.Main){
                    scProgressDialog.dismissDialog()
                }
            }
        }
    }

    override fun onMapReady(p0: GoogleMap?) {
        mMap = p0
        mMap?.setMapStyle(MapStyleOptions.loadRawResourceStyle(this, R.raw.empty_map_style))
        var lat = 0.0
        var lng = 0.0
        try {
            val manager =   this.getSystemService(Context.LOCATION_SERVICE) as LocationManager

            if (ActivityCompat.checkSelfPermission(this,
                    Manifest.permission.ACCESS_FINE_LOCATION) === PackageManager.PERMISSION_GRANTED &&
                ActivityCompat.checkSelfPermission(this,
                    Manifest.permission.ACCESS_COARSE_LOCATION) === PackageManager.PERMISSION_GRANTED){

                if (manager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                    val simpleLocation = SimpleLocation(this)
                    simpleLocation.beginUpdates()
                    lat = simpleLocation.latitude
                    lng = simpleLocation.longitude
                }
            }
        }catch (e:Exception){
            e.printStackTrace()
        }
        val currentLoc = LatLng(lat, lng)
        mMap?.addMarker(MarkerOptions().position(currentLoc).title("Marker").draggable(false))
        mMap?.animateCamera(CameraUpdateFactory.newLatLngZoom(currentLoc, 18f))

        val currentLocations = localDatabase?.appDao()?.tripLocations(currentTrip?.id?:0)
        currentLocations?.let {
            if(currentLocations.isNotEmpty()){
                val distance = localDatabase?.appDao()?.tripDistance(currentTrip?.id?:0)
                distance?.let {
                    binding.txtDistanceValue.text = CommonUtils.calculateDistance(ArrayList(distance))
                    distances = ArrayList(it)
                }
                currentLocations.forEach {
                    addedLocs.add(LatLng(it.latitude,it.longitude))
                }
                mMap?.clear()
                mMap?.addMarker(MarkerOptions().position(addedLocs.last()).title("Marker").draggable(false))
                mMap?.animateCamera(CameraUpdateFactory.newLatLngZoom(addedLocs.last(), 18f))
                drawPolyLine(addedLocs)
            }
        }
    }

    private fun drawPolyLine(list:ArrayList<LatLng>){
        val options = PolylineOptions().apply {
            color(Color.parseColor("#CC0000FF"))
            width(8F)
            visible(true)
        }
        list.forEach { options.add(it) }
        mMap?.addPolyline(options)
    }

    override fun onConnected(p0: Bundle?) {
        var builder = LocationSettingsRequest.Builder().addLocationRequest(mLocationRequest)
        var result = LocationServices.SettingsApi.checkLocationSettings(mGoogleApiClient,builder.build())
        result.setResultCallback { object : ResultCallback<LocationSettingsResult>{
            override fun onResult(p0: LocationSettingsResult) {
                val result = p0.status
            }
        }}
    }

    override fun onConnectionSuspended(p0: Int) {

    }

    private fun initTimer(){
        var i = 0
        val manager =   this@RidePostPaidActivity.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        rideTimer.scheduleAtFixedRate(object:TimerTask(){
            override fun run() {
                Log.d("TagStart",simpleDateFormat.parse(currentTrip?.rideStart).toString())
                Log.d("TagCurrent",simpleDateFormat.parse(simpleDateFormat.format(Date())).toString())
                CoroutineScope(Dispatchers.IO).launch {
                    val timeDiff = CommonUtils.timeDiff(
                        simpleDateFormat.parse(currentTrip?.rideStart),
                        simpleDateFormat.parse(simpleDateFormat.format(Date())))
                    i++
                    if(i == 15){
                        i=0
                        if (ActivityCompat.checkSelfPermission(this@RidePostPaidActivity,
                                Manifest.permission.ACCESS_FINE_LOCATION) === PackageManager.PERMISSION_GRANTED &&
                            ActivityCompat.checkSelfPermission(this@RidePostPaidActivity,
                                Manifest.permission.ACCESS_COARSE_LOCATION) === PackageManager.PERMISSION_GRANTED){
                            if (manager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                                val simpleLocation = SimpleLocation(this@RidePostPaidActivity)
                                withContext(Dispatchers.Main){
                                    simpleLocation.beginUpdates()
                                }
                                var lat = simpleLocation.latitude
                                var lng = simpleLocation.longitude
                                var isValidLoc = true
                                if(addedLocs.size > 0){
                                    val previousLoc = addedLocs[addedLocs.size-1]
                                    if(previousLoc.latitude == lat && previousLoc.longitude == lng){
                                        isValidLoc = false
                                    }
                                }
                                if(isValidLoc){
                                    addedLocs.add(LatLng(lat,lng))
                                    if(addedLocs.size > 1){
                                        val loc1 = Location("A").apply { latitude = addedLocs.last().latitude
                                            longitude = addedLocs.last().longitude}
                                        val loc2 = Location("B").apply { latitude = addedLocs[addedLocs.size-2].latitude
                                            longitude = addedLocs[addedLocs.size-2].longitude}
                                        var res = loc1.distanceTo(loc2)
                                        distances.add(res)
                                        withContext(Dispatchers.Main){
                                            binding.txtDistanceValue.text = CommonUtils.calculateDistance(distances)
                                            mMap?.clear()
                                            drawPolyLine(addedLocs)
                                            mMap?.addMarker(MarkerOptions().position(addedLocs.last()).title("Marker").draggable(false))
                                            mMap?.animateCamera(CameraUpdateFactory.newLatLngZoom(addedLocs.last(), 18f))
                                        }
                                        var locEntity = TripLocEntity().apply {
                                            tripId = currentTrip?.id?:0
                                            tripNo = currentTrip?.tripNo?:""
                                            latitude = addedLocs.last().latitude
                                            longitude = addedLocs.last().longitude
                                            distance = res
                                        }
                                        localDatabase?.appDao()?.newTripLoc(locEntity)
                                    }else if(addedLocs.size == 1){
                                        var locEntity = TripLocEntity().apply {
                                            tripId = currentTrip?.id?:0
                                            tripNo = currentTrip?.tripNo?:""
                                            latitude = addedLocs.last().latitude
                                            longitude = addedLocs.last().longitude
                                            distance = 0F
                                        }
                                        localDatabase?.appDao()?.newTripLoc(locEntity)
                                    }
                                }
                            }
                        }
                    }
                    withContext(Dispatchers.Main){
                        if(timeDiff.split("_")[0] == "0"){
                            binding.txtRideTimeValue.text = timeDiff.split("_")[1]
                        }else{
                            binding.txtRideTimeValue.text = timeDiff.split("_")[0] + "day " + timeDiff.split("_")[1]
                        }
                    }
                }
            }
        },0,1000)
    }

    override fun onRequestPermissionsResult(requestCode: Int,
                                            permissions: Array<String>, grantResults: IntArray) {
        if(requestCode == 200){
            if (grantResults.isEmpty() || grantResults[0] != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(Manifest.permission.ACCESS_FINE_LOCATION,Manifest.permission.ACCESS_COARSE_LOCATION),
                    200)
            } else {
                val simpleLocation = SimpleLocation(this)
                simpleLocation.beginUpdates()
                endRide(simpleLocation.latitude.toString(),simpleLocation.longitude.toString())
            }
        }
    }
}