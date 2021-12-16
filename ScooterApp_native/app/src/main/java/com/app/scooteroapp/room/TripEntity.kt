package com.app.scooteroapp.room

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "TripEntity")
data class TripEntity(
    @PrimaryKey(autoGenerate = true) var id:Int=0,
    @ColumnInfo var tripNo:String="0",
    @ColumnInfo var customerId :String="",
    @ColumnInfo var scooterId: String="",
    @ColumnInfo var paymentId: String="",
    @ColumnInfo var rideStart: String="",
    @ColumnInfo var tripPaymentType: String="",
    @ColumnInfo var isRideEnd: Boolean=false,
    @ColumnInfo var tripTime:String="",
    @ColumnInfo var paidAmount:String="") {
}