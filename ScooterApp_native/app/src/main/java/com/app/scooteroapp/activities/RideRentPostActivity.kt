package com.app.scooteroapp.activities

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.app.scooterapp.activities.DashboardActivity
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityRideRentPostBinding
import com.app.scooteroapp.room.LocalDatabase
import com.app.scooteroapp.room.TripDetailEntity
import com.app.scooteroapp.utility.UiUtils
import com.bumptech.glide.Glide

class RideRentPostActivity : AppCompatActivity() {
    lateinit var binding : ActivityRideRentPostBinding
    private var tripId : String? = ""
    var vat_charge:String? = ""
    var creditTripEntity : TripDetailEntity? = null
    var localDatabase : LocalDatabase? = null
    lateinit var activityContext : Context

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityRideRentPostBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()
        activityContext = this
        tripId = intent.extras?.getString("tripId")
        vat_charge = DevicePreferences.getSharedPreference(this@RideRentPostActivity,Constants.VATT, SealedPreference.STRING) as String
        localDatabase = LocalDatabase.getAppDatabase(this)
        creditTripEntity = localDatabase?.appDao()?.creditTripDetail(Integer.parseInt(tripId?:"0"))

        with(binding){
            txtHeader.text = UiUtils.langValue(activityContext,"GENERIC_RIDE_RENT")
            txtTitle.text = UiUtils.langValue(activityContext,"GENERIC_RIDE_PAYMENT")
            txtStartTime.text = UiUtils.langValue(activityContext,"GENERIC_START_TIME")
            txtEndTime.text = UiUtils.langValue(activityContext,"GENERIC_END_TIME")
            txtRideDistance.text = UiUtils.langValue(activityContext,"GENERIC_RIDE_DISTANCE")
            txtUnlock.text = UiUtils.langValue(activityContext,"GENERIC_UNLOCK_CHARGE")
            txtSubTotal.text = UiUtils.langValue(activityContext,"GENERIC_SUB_TOTAL")
            txtVatValue.text = UiUtils.langValue(activityContext,"GENERIC_VAT")
            txtGrandTotal.text = UiUtils.langValue(activityContext,"GENERIC_GRAND_TOTAL")
            btnContinue.text = UiUtils.langValue(activityContext,"GENERIC_CONTINUE")
            txtReport.text = UiUtils.langValue(activityContext,"GENERIC_REPORT_ISSUE_MSG")
        }
        val totalRideTimeLabel = UiUtils.langValue(activityContext,"GENERIC_TOTAL_RIDE_TIME")
        creditTripEntity?.let {
            with(binding){
                txtStartTimeValue.text = it.rideStart
                txtEndTimeValue.text = it.rideEnd
                txtRideDistanceValue.text = "${it.rideDistance}km"
                txtRideTimeLabel.text = "$totalRideTimeLabel-${it.rideMins}"
                txtRideRentValue.text = "${it.totalRideAmt}SAR"
                txtUnlockChargeValue.text = "${it.unlockCharge}SAR"
                txtSubTotalValue.text = "${it.subTotal}SAR"
                txtVatValue.text = "${it.vatCharge}SAR"
                txtGrandTotalValue.text = "${it.grandTotal}SAR"
            }
        }

        binding.btnContinue.setOnClickListener {
            Intent(this,FeedbackActivity::class.java).apply {
                putExtra("ScooterId",creditTripEntity?.scooterId)
                putExtra("serverTripId",creditTripEntity?.serverTripId)
            }.also {
                startActivity(it)
            }
        }



        binding.imgBack.setOnClickListener {
            Intent(this, DashboardActivity::class.java).also {
                startActivity(it)
                finish()
            }
        }

        binding.txtReport.setOnClickListener {
            Intent(this,ContactSupportActivity::class.java).also {
                startActivity(it)
            }
        }
        loadMap()
    }

    private fun loadMap(){
        /*var list = ArrayList<LatLng>()
        list.add(LatLng(11.043831,76.9435437))
        list.add(LatLng(11.044336,76.9434897))
        list.add(LatLng(11.044689,76.9434737))
        list.add(LatLng(11.044726,76.9438497))
        list.add(LatLng(11.044663,76.9453357))
        list.add(LatLng(11.044663,76.9463867))
        list.add(LatLng(11.043241,76.9469497))

        list.forEach {
            var locEntit = TripLocEntity().apply {
                tripId = 1
                latitude = it.latitude
                longitude  = it.longitude
            }
            localDatabase?.appDao()?.newTripLoc(locEntit)
        }*/
        var locEntity = localDatabase?.appDao()?.tripLocations(tripId?.toInt()?:0)
        var locations = ""
        locEntity?.forEach {
            locations = "${locations}|${it.latitude},${it.longitude}"
        }
        var url = "http://maps.googleapis.com/maps/api/staticmap?&size=600x400&path=color:0x0000ff|weight:5" +
                locations +
                "&key=AIzaSyBnxC-LAyBEDC3F4EZ7xs_4f5Pgr15WU68"
        Glide.with(this).load(url).into(binding.imgMap)
    }
}