package com.app.scooteroapp.entities

data class ChangeEmailResponse(var status:String="",var message:String,var data:LoginResponse.CustomerDetails = LoginResponse.CustomerDetails())