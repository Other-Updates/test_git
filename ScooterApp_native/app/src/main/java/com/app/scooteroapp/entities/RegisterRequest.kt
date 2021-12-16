package com.app.scooteroapp.entities

data class RegisterRequest(var name:String="",var mobile_number:String="",var dob:String="",
        var gender:String="",var email:String="",var password:String="",var googleid:String="",var isGoogle:Boolean = false)