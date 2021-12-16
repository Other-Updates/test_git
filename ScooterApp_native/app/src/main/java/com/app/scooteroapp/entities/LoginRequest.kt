package com.app.scooteroapp.entities

data class LoginRequest(var mobile_number:String="",var password:String="",var isGoogle:Boolean = false,var googleid:String="")