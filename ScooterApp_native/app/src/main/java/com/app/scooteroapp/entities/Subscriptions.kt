package com.app.scooteroapp.entities

data class Subscriptions(var type:String="",var isSelected:Boolean = false,var subscriptionDetail:SubscriptionResponse.SubscriptionDetail = SubscriptionResponse.SubscriptionDetail(),
                         var totalRideRent:String="",var unlockCharge:String="",var subTotal:String="",var vat:String="",var grandTotal:String="") {
}