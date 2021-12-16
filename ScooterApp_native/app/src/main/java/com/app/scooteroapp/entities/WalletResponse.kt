package com.app.scooteroapp.entities

data class WalletResponse(var status:String="",var message:String="",var data:ArrayList<Data> = ArrayList()) {
    data class Data(var wallet:ArrayList<Wallet>,var walletDetails:ArrayList<WalletDetails>)
    data class Wallet(var id:String="",var amount:String="",var created_date:String="")
    data class WalletDetails(var type:String="",var amount:String="",var created_date:String="")
}