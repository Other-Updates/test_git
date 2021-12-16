package com.app.scooteroapp.entities

data class DebitPaymentResponse(var status:String="",var message:String="",var trip_details:DebitTripDetails = DebitTripDetails()) {
    data class DebitTripDetails(var trip_number:String="",var customer_id:String="",var scooter_id:String="",
                           var payment_id:String="",var subscription_id:String="",var ride_start:String="",
                           var ride_mins:String="",var total_ride_amt:String="",var unlock_charge:String="",
                           var sub_total:String="",var vat_charge:String="",var grand_total:String="",var created_date:String="")
}