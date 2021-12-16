package com.app.scooteroapp.room

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import java.lang.Exception

@Database(entities = [CardEntity::class,TripEntity::class,TripLocEntity::class,
    TripDetailEntity::class],version = 7)

abstract class LocalDatabase:RoomDatabase(){
    abstract fun appDao() : AppDao
    companion object{
        private var INSTANCE: LocalDatabase? = null

        fun getAppDatabase(context:Context): LocalDatabase?{
            try {
            if(INSTANCE == null){
                INSTANCE = Room.databaseBuilder(context.applicationContext,
                        LocalDatabase::class.java,"scooteroDB")
                    .allowMainThreadQueries()
                    .fallbackToDestructiveMigration()
                    .build()
            }
            }catch (e:Exception){}
            return INSTANCE
        }
    }
}