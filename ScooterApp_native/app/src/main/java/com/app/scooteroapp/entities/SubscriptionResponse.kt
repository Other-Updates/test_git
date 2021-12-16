package com.app.scooteroapp.entities

data class SubscriptionResponse(var status:String="",var message:String="",var subscription_details:ArrayList<SubscriptionDetail> = ArrayList()) {
    data class SubscriptionDetail(var id:String="",var name:String="",var mins:String="",var amount:String="")
}