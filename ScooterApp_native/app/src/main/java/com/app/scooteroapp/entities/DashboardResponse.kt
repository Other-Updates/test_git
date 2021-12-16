package com.app.scooteroapp.entities

data class DashboardResponse(var status:String="",var message:String,var data:DashboardDet = DashboardDet()){
    data class DashboardDet(
        var unlock_counts:String="",var total_distance:String="",
        var wallet_amount:String="",var total_ride_time:String=""
    )
}