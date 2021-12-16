package com.app.scooteroapp.entities

data class CreditedDetailsResponse (var status:String=" ",var message:String=" ",var data:ArrayList<Data> = ArrayList()){
    data class Data(
var amount:String=" ",var created_date:String=" ",var pay_description:String=" ",var card:String=" ",var txn_no:String=""

)
}