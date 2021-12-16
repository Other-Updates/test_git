package com.app.scooteroapp.entities

data class UnlockScooterRequest(var id:String="", var qr_code:String="",var customer_id:String="",
    var scoo_lat:String="",var scoo_long:String="")