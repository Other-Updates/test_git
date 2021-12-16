package com.app.scooteroapp.entities

data class UnlockScooterResponse(var status:String="",var message:String="",var scootoro_details: UnlockScooterDetail = UnlockScooterDetail()) {
    data class UnlockScooterDetail(var scooter_id:String="",var serial_number:String="",var battery_life:String="")
}