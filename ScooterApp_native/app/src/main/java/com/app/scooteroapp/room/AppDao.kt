package com.app.scooteroapp.room

import androidx.room.*

@Dao
interface AppDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun newCard(cardEntity: CardEntity)

    @Query("SELECT * FROM CardEntity")
    fun cardsList() : List<CardEntity>

    @Query("SELECT * FROM CardEntity where id=:id")
    fun card(id:String) : CardEntity

    @Query("SELECT * FROM CardEntity where type=:type")
    fun getCreditCard(type:String) : CardEntity

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun newTrip(tripEntity: TripEntity)

    @Query("SELECT * FROM TripEntity where isRideEnd=:isRideEnd")
    fun openTrip(isRideEnd:Boolean = false) : TripEntity

    @Query("SELECT * FROM TripEntity where id=:id")
    fun trip(id:Int) : TripEntity

    @Update
    fun updateTrip(tripEntity: TripEntity?)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun newTripLoc(tripLocEntity: TripLocEntity)

    @Query("SELECT * FROM TripLocEntity WHERE tripId=:tripId")
    fun tripLocations(tripId:Int): List<TripLocEntity>

    @Query("SELECT distance FROM TripLocEntity WHERE tripId=:tripId")
    fun tripDistance(tripId:Int): List<Float>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun newTripDetail(tripDetailEntity: TripDetailEntity)

    @Query("SELECT * FROM TripDetailEntity WHERE tripId=:tripId")
    fun creditTripDetail(tripId: Int) : TripDetailEntity
}