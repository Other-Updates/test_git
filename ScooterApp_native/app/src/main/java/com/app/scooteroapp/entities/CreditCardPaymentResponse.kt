package com.app.scooteroapp.entities

data class CreditCardPaymentResponse(var status:String="",var message:String="",var trip_details:TripDetails = TripDetails()) {
    data class TripDetails(var trip_number:String="",var customer_id:String="",var scooter_id:String="",
                            var payment_id:String="",var ride_start:String="",var created_date:String="")
}