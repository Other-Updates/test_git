package com.app.scooteroapp.constants

sealed class SealedPreference {
    object STRING : SealedPreference()
    object INTEGER : SealedPreference()
    object BOOLEAN : SealedPreference()
    object FLOAT : SealedPreference()
    object LONG : SealedPreference()
}