package com.app.scooteroapp.room

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "TripLocEntity")
data class TripLocEntity(
    @PrimaryKey(autoGenerate = true) var id:Int=0,
    @ColumnInfo var tripId:Int=0,
    @ColumnInfo var tripNo:String="0",
    @ColumnInfo var latitude :Double = 0.0,
    @ColumnInfo var longitude :Double = 0.0,
    @ColumnInfo var distance: Float=0F) {
}