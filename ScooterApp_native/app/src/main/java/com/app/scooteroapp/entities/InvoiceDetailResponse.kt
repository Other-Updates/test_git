package com.app.scooteroapp.entities

data class InvoiceDetailResponse(var status:String="",var message:String="",var data:InvoiceDetail = InvoiceDetail()) {
    data class InvoiceDetail(var id:String="",var trip_number:String="",var scootoro_number:String="",var start_time:String="",
                             var end_time: String="",var ride_distance:String="",var total_ride_time:String="",var total_ride_amt:String="",
                             var unlock_charge:String="",var sub_total:String="",var vat_charge:String="",var grand_total:String="")
}