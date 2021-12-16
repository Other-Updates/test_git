package com.app.scooteroapp.room

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "TripDetailEntity")
data class TripDetailEntity(
    @PrimaryKey(autoGenerate = true) var id:Int=0,
    @ColumnInfo var tripId:Int=0,
    @ColumnInfo var serverTripId:String="",
    @ColumnInfo var tripNumber:String="",
    @ColumnInfo var subscriptionId:String="",
    @ColumnInfo var rideEnd:String="",
    @ColumnInfo var rideDistance:String="",
    @ColumnInfo var rideMins:String="",
    @ColumnInfo var totalRideAmt:String="",
    @ColumnInfo var unlockCharge:String="",
    @ColumnInfo var subTotal:String="",
    @ColumnInfo var vatCharge:String="",
    @ColumnInfo var grandTotal:String="",
    @ColumnInfo var status:String="",
    @ColumnInfo var customerId :String="",
    @ColumnInfo var scooterId: String="",
    @ColumnInfo var paymentId: String="",
    @ColumnInfo var rideStart: String="") {
}