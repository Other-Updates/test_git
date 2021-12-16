package com.app.scooteroapp.entities

data class ForgotResponse(var status:String="",var message:String,var data:LoginResponse.CustomerDetails = LoginResponse.CustomerDetails())