package com.app.scooteroapp.entities

import com.google.gson.JsonObject
import org.json.JSONObject

data class LanguageResponse(var status:String="",var message:String="",var data : JsonObject = JsonObject())