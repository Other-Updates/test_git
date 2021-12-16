package com.app.scooteroapp.entities

data class DebitPaymentRequest(var id:String="",var scootoro_id:String="",var subscription_id:String="",
                                var ride_time_taken:String="",var total_ride_rent:String="",var unlock_charge:String="",
                                var total_rent:String="",var vat_charge:String="",var grand_total:String="",
                                var payment_method:String="",var card_holder_name:String="",var card_number:String="",
                                var expire_year:String="",var expire_month:String="",var cvv:String="",var amount:String="") {
}