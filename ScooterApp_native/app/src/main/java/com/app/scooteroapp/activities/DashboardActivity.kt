package com.app.scooterapp.activities


import android.Manifest
import android.annotation.SuppressLint
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import android.graphics.Color
import android.location.Geocoder
import android.location.LocationManager
import android.os.Bundle
import android.util.Log
import android.view.Gravity
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import com.app.scooteroapp.R
import com.app.scooteroapp.activities.*
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityDashboardBinding
import com.app.scooteroapp.entities.DashboardRequest
import com.app.scooteroapp.entities.GetScootersRequest
import com.app.scooteroapp.fragments.MarkerInfoView
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.SimpleLocation
import com.app.scooteroapp.utility.UiUtils
import com.beust.klaxon.*
import com.directions.route.*
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.*
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.layout_drawer.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.*
import kotlin.collections.ArrayList


class DashboardActivity : AppCompatActivity(), OnMapReadyCallback,RoutingListener {

    private lateinit var mMap: GoogleMap
    private lateinit var mGeoCoder: Geocoder
    lateinit var binding: ActivityDashboardBinding
    private var scProgressDialog = SCProgressDialog()
    protected  var start: LatLng? = null
    protected var end: LatLng? = null
    lateinit var scooterID : String



    //polyline object
    private  var polylines: MutableList<Polyline>? = ArrayList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityDashboardBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()

        val mapFragment = supportFragmentManager
            .findFragmentById(R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)
        mGeoCoder = Geocoder(this)
        txtUsername.text = DevicePreferences.getSharedPreference(
            this,
            Constants.USER_NAME,
            SealedPreference.STRING
        ) as String
        initListeners()
        getDashboardDetails()
    }


    @SuppressLint("RtlHardcoded")
    private fun initListeners() {
        binding.crdBarcode.setOnClickListener {
            Intent(this, ScanActivity::class.java).also {
                startActivity(it)
            }
        }
        binding.imgDrawer.setOnClickListener { binding.drawerLayout.openDrawer(Gravity.LEFT) }
        binding.crdLocation.setOnClickListener {
            var lat = 0.0
            var lng = 0.0
            try {
                val manager = this.getSystemService(LOCATION_SERVICE) as LocationManager

                if (ActivityCompat.checkSelfPermission(
                        this,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    ) === PackageManager.PERMISSION_GRANTED &&
                    ActivityCompat.checkSelfPermission(
                        this,
                        Manifest.permission.ACCESS_COARSE_LOCATION
                    ) === PackageManager.PERMISSION_GRANTED
                ) {

                    if (manager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                        val simpleLocation = SimpleLocation(this)
                        simpleLocation.beginUpdates()
                        lat = simpleLocation.latitude
                        lng = simpleLocation.longitude
                    }
                } else {
                    ActivityCompat.requestPermissions(
                        this,
                        arrayOf(
                            Manifest.permission.ACCESS_FINE_LOCATION,
                            Manifest.permission.ACCESS_COARSE_LOCATION
                        ),
                        200
                    )
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
            val currentLoc = LatLng(lat, lng)
            mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(currentLoc, 14f))
        }

        llProfile.setOnClickListener {
            Intent(this, ProfileActivity::class.java).also { startActivity(it) }
        }
        llWallet.setOnClickListener {
            Intent(this, WalletActivity::class.java).also { startActivity(it) }
        }
        /*   llPayments.setOnClickListener {
            Intent(this,PaymentsActivity::class.java).also { startActivity(it) }
        }*/
        llInvoice.setOnClickListener {
            Intent(this, InvoiceListActivity::class.java).also { startActivity(it) }
        }
        llInvite.setOnClickListener { }
        llHelp.setOnClickListener { }
        llSettings.setOnClickListener {
            Intent(this, SettingsActivity::class.java).also { startActivity(it) }
        }
        llPromoCode.setOnClickListener { }
        llLogout.setOnClickListener {
            DevicePreferences.clearPreference(this).also {
                Log.d(
                    "loggedIn",
                    DevicePreferences.getSharedPreference(
                        this,
                        Constants.USER_ID,
                        SealedPreference.STRING
                    ) as String
                )
                Intent(this, LoginActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                    addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }.also {
                    startActivity(it)
                    finish()
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        txtHi.text = UiUtils.langValue(this, "GENERIC_HI")
        txtUnlocks.text = UiUtils.langValue(this, "GENERIC_UNLOCKS")
        txtDistance.text = UiUtils.langValue(this, "GENERIC_DISTANCE")
        txtMinutes.text = UiUtils.langValue(this, "GENERIC_MINUTES")
        txtProfile.text = UiUtils.langValue(this, "GENERIC_PROFILE")
        txtWallet.text = UiUtils.langValue(this, "GENERIC_WALLET")
        txtWalletAr.text = UiUtils.langValue(this, "GENERIC_WALLET")
        txtInvite.text = UiUtils.langValue(this, "GENERIC_INVITE_FRDS")
        //     txtPayments.text = UiUtils.langValue(this,"GENERIC_PAYMENTS")
        txtInvoice.text = UiUtils.langValue(this, "GENERIC_INVOICE")
        txtHelp.text = UiUtils.langValue(this, "GENERIC_HELP")
        txtSettings.text = UiUtils.langValue(this, "GENERIC_SETTINGS")
        txtPromoCode.text = UiUtils.langValue(this, "GENERIC_PROMO_CODE")
        txtLogout.text = UiUtils.langValue(this, "GENERIC_LOGOUT")
        if (DevicePreferences.getSharedPreference(
                this,
                Constants.LANGUAGE,
                SealedPreference.STRING
            ) as String == "ENGLISH"
        ) {
            txtWallet.visibility = View.VISIBLE
            txtWalletAmount.visibility = View.VISIBLE
            txtWalletAr.visibility = View.GONE
            txtWalletAmountAr.visibility = View.GONE
        } else if (DevicePreferences.getSharedPreference(
                this,
                Constants.LANGUAGE,
                SealedPreference.STRING
            ) as String == "ARABIC"
        ) {
            txtWallet.visibility = View.GONE
            txtWalletAmount.visibility = View.GONE
            txtWalletAr.visibility = View.VISIBLE
            txtWalletAmountAr.visibility = View.VISIBLE
        } else {
            txtWallet.visibility = View.VISIBLE
            txtWalletAmount.visibility = View.VISIBLE
            txtWalletAr.visibility = View.GONE
            txtWalletAmountAr.visibility = View.GONE
        }
    }

    private fun getDashboardDetails() {
        val dashboardReq = DashboardRequest(
            DevicePreferences.getSharedPreference(
                this,
                Constants.USER_ID,
                SealedPreference.STRING
            ) as String
        )
        CoroutineScope(Dispatchers.IO).launch {
            val response = ApiCall.dashboardDet(dashboardReq)
            if (response.isSuccessful) {
                if (response.body()?.status?.toLowerCase() == "success") {
                    withContext(Dispatchers.Main) {
                        txtUnlockValue.text = response.body()?.data?.unlock_counts
                        txtDistanceValue.text = response.body()?.data?.total_distance
                        txtMinutesValue.text = response.body()?.data?.total_ride_time
                        txtWalletAmount.text = response.body()?.data?.wallet_amount
                        txtWalletAmountAr.text = response.body()?.data?.wallet_amount
                        DevicePreferences.setSharedPreference(
                            this@DashboardActivity,
                            Constants.WALLET_AMOUNT,
                            txtWalletAmount.text
                        )
                    }
                }
            }
        }
    }

    override fun onMapReady(googleMap: GoogleMap) {
        mMap = googleMap
        mMap.setMapStyle(MapStyleOptions.loadRawResourceStyle(this, R.raw.empty_map_style))
        setCurrentLocation()

    }

    private fun setCurrentLocation() {
        var lat = 0.0
        var lng = 0.0
        try {
            val manager = this.getSystemService(LOCATION_SERVICE) as LocationManager

            if (ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.ACCESS_FINE_LOCATION
                ) === PackageManager.PERMISSION_GRANTED &&
                ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.ACCESS_COARSE_LOCATION
                ) === PackageManager.PERMISSION_GRANTED
            ) {

                if (manager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                    val simpleLocation = SimpleLocation(this)
                    simpleLocation.beginUpdates()
                    lat = simpleLocation.latitude
                    lng = simpleLocation.longitude
                }
            } else {
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(
                        Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.ACCESS_COARSE_LOCATION
                    ),
                    200
                )
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        val currentLoc = LatLng(lat, lng)

        mMap.clear()

        //map.getUiSettings().setZoomControlsEnabled(true);
        mMap.setMyLocationEnabled(true)
        mMap.getUiSettings().setMyLocationButtonEnabled(false)
        mMap.uiSettings.isMapToolbarEnabled = false


        //  mMap.addMarker(MarkerOptions().position(currentLoc).title("Marker").draggable(false))
        mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(currentLoc, 14f))
        scProgressDialog.showDialog(this, "Finding scooter routes")

        var getScootersRequest = GetScootersRequest(
            DevicePreferences.getSharedPreference(
                this,
                Constants.USER_ID,
                SealedPreference.STRING
            ) as String
        )
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = ApiCall.scooterDetails(getScootersRequest)
                if (response.isSuccessful) {
                    if (response.body()?.status == "Success") {
                        withContext(Dispatchers.Main) {
                            scProgressDialog.dismissDialog()
                            var scooters = response.body()?.data


                            val bitmap =
                                BitmapFactory.decodeResource(
                                    resources,
                                    R.drawable.ic_sc_maker_3
                                )

                            scooters?.forEachIndexed { index, scooterDetails ->
                                if (scooterDetails.gps == "ON" && scooterDetails.lock_status == "0") {
                                    scooterDetails.scoo_lat?.let {

                                   mMap.addMarker(
                                            MarkerOptions()
                                                .position(
                                                    LatLng(
                                                        it.toDouble(),
                                                        scooterDetails.scoo_long?.toDouble()
                                                            ?: 0.0
                                                    )
                                                ).infoWindowAnchor(2F, 2.5F)
                                                .draggable(false)
                                                .icon(BitmapDescriptorFactory.fromBitmap(bitmap))

                                        ).tag = scooterDetails

                                    }
                                   // mMap.setOnMarkerClickListener(this)
                                    mMap.setOnMarkerClickListener { marker ->
                                           // polylines?.clear()
                                        marker.showInfoWindow()
                                        Log.d("success","markergggloct"+marker.getPosition())
                                        end = marker.getPosition()

                                        Log.d("success","markerloct"+end)
                                         scooterID = scooterDetails.id
                                        start = currentLoc
                                        Findroutes(start, end,scooterID)


                                        //start route finding
                                        return@setOnMarkerClickListener true
                                    }

                                    val scootero=LatLng(
                                        scooterDetails.scoo_lat?.toDouble()
                                            ?: 0.0,
                                        scooterDetails.scoo_long?.toDouble()
                                            ?: 0.0
                                    )

                                }

                                // .addPolyline(PolylineOptions().add(LatLng(lat,lng), LatLng(scooterDetails.scoo_lat,scooterDetails.scoo_long)).width(8F).color(Color.parseColor("#CC0000FF")))


                            }
                            var infoWindow = MarkerInfoView(this@DashboardActivity)
                            mMap.setInfoWindowAdapter(infoWindow)



                        }
                    } else {
                        withContext(Dispatchers.Main) {
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(
                                this@DashboardActivity,
                                response.body()?.message.toString()
                            )
                        }

                    }
                } else {
                    withContext(Dispatchers.Main) {
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@DashboardActivity, "Unable to get scooter details")
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
                withContext(Dispatchers.Main) {
                    scProgressDialog.dismissDialog()
                    UiUtils.showToast(this@DashboardActivity, "Unable to get scooter details")
                }
            }
        }


    }



    fun Findroutes(Start: LatLng?, End: LatLng?, scooterID: String) {
        if (Start == null || End == null) {
            Toast.makeText(this@DashboardActivity, "Unable to get location", Toast.LENGTH_LONG).show()
        }else {
            var routing = Routing.Builder()
                .travelMode(AbstractRouting.TravelMode.DRIVING)
                .withListener(this)
                .alternativeRoutes(true)
                .waypoints(Start, End)
                .key("AIzaSyDwpXSYswuXaJyfDoBxXTxYeAYRwzZIjGE") //also define your api key here.
                .build()
            routing.execute()
        }
    }




    //Routing call back functions.
    override fun onRoutingFailure(e: RouteException) {
      /*  val parentLayout = findViewById<View>(android.R.id.content)
        val snackbar = Snackbar.make(parentLayout, e.toString(), Snackbar.LENGTH_LONG)
        snackbar.show()*/
        //        Findroutes(start,end);
    }



    override fun onRoutingStart() {
     //   Toast.makeText(this@DashboardActivity, "Finding Route...", Toast.LENGTH_LONG).show()
    }

    //If Route finding success..
    override fun onRoutingSuccess(route: ArrayList<com.directions.route.Route>, scooterID: Int) {
        val center = CameraUpdateFactory.newLatLng(start)
        val zoom = CameraUpdateFactory.zoomTo(16f)
        if (polylines != null) {
            mMap!!.clear()
            setCurrentLocation()
        }
       //Log.d("success","shfjshfjs"+mMap)

        val polyOptions = PolylineOptions()
        var polylineStartLatLng: LatLng? = null
        var polylineEndLatLng: LatLng? = null
        polylines = ArrayList()

        //add route(s) to the map using polyline
        Log.d("success","testetest"+mMap)
        for (i in route.indices) {

            if (i == scooterID) {
                Log.d("success","logloop"+i);
                Log.d("success","logloopscooterID"+scooterID);
                polyOptions.color(Color.parseColor("#00DD00"))
                polyOptions.width(15f)
                Log.d("success","ScooterRoure"+route[scooterID])


                polyOptions.addAll(route[scooterID].points)

                val polyline = mMap.addPolyline(polyOptions)

                //       polyline.setPoints(scooterID)
                polylineStartLatLng = polyline!!.points[0]
              //  val k = polyline!!.points.size
                polylineEndLatLng = polyline.points[1]

//                polyline!!.add(polyline, scooterID.toString())

            }
        }

        //Add Marker on route starting position
       /* val startMarker = MarkerOptions()
        startMarker.position(polylineStartLatLng!!)
        startMarker.title("My Location")
        mMap!!.addMarker(startMarker)*/

        //Add Marker on route ending position
      /*  val endMarker = MarkerOptions()
        endMarker.position(polylineEndLatLng!!)
        endMarker.title("Destination")
        mMap!!.addMarker(endMarker)*/
    }


    override fun onRoutingCancelled() {
        Findroutes(start, end,scooterID)
    }

    fun onConnectionFailed(connectionResult: ConnectionResult) {
        Findroutes(start, end,scooterID)
    }

    companion object {
        //to get location permissions.
        private const val LOCATION_REQUEST_CODE = 23
    }


    private fun Polyline.add(polyline: Polyline?,scooterID:String) {

    }
    private fun GoogleMap.addPolyline(polyOptions: PolylineOptions, scooterID: String): Polyline? {
      TODO()
    }







    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>, grantResults: IntArray
    ) {
        if (requestCode == 200) {
            if (grantResults.isEmpty() || grantResults[0] != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(
                        Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.ACCESS_COARSE_LOCATION
                    ),
                    200
                )
            } else {
                setCurrentLocation()
            }

        }
    }

}










