package com.app.scooteroapp.fragments

import android.content.Context
import android.view.LayoutInflater
import com.app.scooteroapp.R
import android.view.View
import android.widget.TextView
import com.app.scooteroapp.entities.GetScootersResponse
import com.app.scooteroapp.utility.UiUtils
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.model.Marker


class MarkerInfoView(var context: Context) : GoogleMap.InfoWindowAdapter {
    private val markerItemView: View

    override fun getInfoWindow(marker: Marker): View { // 2
        val scooter = marker.tag as GetScootersResponse.ScooterDetails
        val scooterName = markerItemView.findViewById<TextView>(R.id.txtScooterId)
        val battery = markerItemView.findViewById<TextView>(R.id.txtBatteryPercent)
        scooterName.text = UiUtils.langValue(context,"GENERIC_SCOOTERO") + " " + scooter.serial_number
        battery.text = UiUtils.langValue(context,"GENERIC_BATTERY") + " " + scooter.battery_life



        /*val user: User = marker.tag as User? ?: return clusterItemView // 3
        val itemNameTextView =
            markerItemView.findViewById<TextView>(R.id.itemNameTextView)
        val itemAddressTextView =
            markerItemView.findViewById<TextView>(R.id.itemAddressTextView)
        itemNameTextView.text = marker.title
        itemAddressTextView.setText(user.getAddress())*/
        return markerItemView // 4
    }

    override fun getInfoContents(marker: Marker): View? {
        return null
    }

    init {
        markerItemView = LayoutInflater.from(context).inflate(R.layout.layout_marker, null) // 1
    }
}