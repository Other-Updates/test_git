package com.app.scooteroapp.entities

data class CreditCardPaymentRequest(var id:String="",var scootoro_id:String="",
                                    var payment_method:String="",var card_holder_name:String="", var card_number:String="",
                                    var expire_year:String="",var expire_month:String="",var cvv:String="",var amount:String="")