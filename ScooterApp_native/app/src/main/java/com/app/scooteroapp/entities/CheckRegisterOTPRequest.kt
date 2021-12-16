package com.app.scooteroapp.entities

data class CheckRegisterOTPRequest(var otp_code:String="",var email:String="",var mobile_number:String="")