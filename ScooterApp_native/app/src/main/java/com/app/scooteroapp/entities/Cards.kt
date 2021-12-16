package com.app.scooteroapp.entities

import com.app.scooteroapp.room.CardEntity

data class Cards(var name:String="",var number:String="",var expiry:String="",var cardEntity: CardEntity = CardEntity(),var isSelected:Boolean=false)