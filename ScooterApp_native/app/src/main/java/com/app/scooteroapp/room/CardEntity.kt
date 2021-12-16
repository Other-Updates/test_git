package com.app.scooteroapp.room

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "CardEntity")
data class CardEntity(
    @PrimaryKey(autoGenerate = true) var id:Int=0,
    @ColumnInfo var name:String="0",
    @ColumnInfo var number :String="",
    @ColumnInfo var month: String="",
    @ColumnInfo var year: String="",
    @ColumnInfo var cvv: String="",
    @ColumnInfo var type: String="") {
}