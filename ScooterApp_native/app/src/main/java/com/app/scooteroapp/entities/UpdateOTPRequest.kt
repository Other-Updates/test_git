package com.app.scooteroapp.entities

data class UpdateOTPRequest(var id:String="",var type:String="",var data:String="",
                            var mobile_number:String="",var otp_code:String="")