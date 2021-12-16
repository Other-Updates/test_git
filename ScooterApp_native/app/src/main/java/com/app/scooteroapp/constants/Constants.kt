package com.app.scooteroapp.constants

import com.app.scooteroapp.entities.RegisterRequest

internal object Constants {

    const val BASE_URL = "https://demo.f2fsolutions.co.in/ScooterO/api/"
//    const val BASE_URL ="https://portal.scooteroride.com/api/"

    const val PREFERENCE_NAME = "SCOOTER_PREF"
    const val LANGUAGE = "LANGUAGE"
    const val IS_TUTORIAL = "IS_TUTORIAL"
    const val IS_LOGGED_IN = "IS_LOGGED_IN"

    const val OTP_FORGOT_PASS_TYPE = "ForgotPassword"
    const val ACK_TYPE = "AcknowledgementType"
    const val ACK_UPDATE_PROFILE="ProfileUpdate"
    const val ACK_RIDE_COMPLETE = "RideComplete"

    const val USER_EMAIL = "UserEmail"
    const val USER_ID = "UserId"
    const val USER_GENDER = "UserGender"
    const val PASSWORD = "UserPassword"
    const val DOB = "UserDob"
    const val USER_MOB_NO = "MobileNo"
    const val USER_NAME = "UserName"
    const val CONTACT_EMAIL = "contact_email"
    const val UNLOCK_CHARGE = "unlock_charge"
    const val VATT = "vatt"
    const val COPY_RIGTH = "copy_right"
    const val SITE_ADDRESS = "site_address"

    const val PAYMENT_METHOD = "PaymentMethod"
    const val PAYMENT_DEBIT = "Debit"
    const val PAYMENT_CREDIT = "Credit"

    const val LANG_CONTENT = "LangContent"

    var loginRequest = RegisterRequest()

    const val WALLET_AMOUNT = "WalletAmount"
}