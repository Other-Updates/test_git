package com.app.scooteroapp.entities

data class InvoiceListResponse(var status:String,var message:String="",var data : ArrayList<Invoice> = ArrayList()) {
    data class Invoice(var id:String="",var trip_number:String="",var amount:String="",var date:String="")
}