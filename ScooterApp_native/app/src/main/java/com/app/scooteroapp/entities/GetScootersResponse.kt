package com.app.scooteroapp.entities

data class GetScootersResponse(var status:String="",var message:String="",var data : ArrayList<ScooterDetails> = ArrayList()) {
    data class ScooterDetails(var id:String="",var serial_number:String="",var battery_life:String="",var scoo_lat:String?="",var scoo_long:String?="",var gps:String?="",var lock_status:String?="")
}