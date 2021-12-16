package com.app.scooteroapp.entities

data class LoginResponse(var status:String="",var message:String="",var data : LoginDetail = LoginDetail()) {
    data class LoginDetail(var customer_details:CustomerDetails = CustomerDetails(),var settings:SettingsDetails = SettingsDetails())
    data class CustomerDetails(var id:String="",var name:String="",var mobile_number:String="",var dob:String="",
            var gender:String="",var email:String="",var plain_password:String="")
    data class SettingsDetails(var id:String="",var contact_email:String="",var unlock_charge:String="",
            var vatt:String="",var copy_right:String="",var site_address:String="")
}