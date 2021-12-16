package com.app.scooteroapp.entities

data class EndRideResponse(var status:String="",var message:String="",var trip_details:EndRideDetails = EndRideDetails()){
    data class EndRideDetails(var id:String="",var trip_number:String="",var customer_id:String="",
                              var scooter_id:String="",var subscription_id:String="",var payment_id:String="",
                              var ride_start:String="",var ride_end:String="",var ride_distance:String="",var ride_mins:String?="",
                              var total_ride_amt:String="",var unlock_charge:String="",var sub_total:String="",var vat_charge:String="",
                              var grand_total:String="",var status:String="",var created_date:String="",var updated_date:String="")
}