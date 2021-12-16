package com.app.scooteroapp.activities

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.scooteroapp.adapters.CardAdapter
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityRechargeOptionsBinding
import com.app.scooteroapp.entities.Cards
import com.app.scooteroapp.entities.DebitPaymentRequest
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.payment.PayActivity
import com.app.scooteroapp.payment.PaymentConstants
import com.app.scooteroapp.room.LocalDatabase
import com.app.scooteroapp.room.TripEntity
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class RechargeOptionsActivity : AppCompatActivity() {
    lateinit var binding : ActivityRechargeOptionsBinding
    lateinit var cardAdapter: CardAdapter
    private var isCardSelected = false
    private lateinit var selectedCard : Cards
    var cardsList = ArrayList<Cards>()
    private var scooterId:String?=null
    var subscriptionId:String?=""
    var rideTimeTaken:String?=""
    var totalRideRent:String?=""
    var unlockCharge:String?=""
    var totalRent:String?=""
    var vatCharge:String?=""
    var grandTotal:String?=""
    val scProgressDialog = SCProgressDialog()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityRechargeOptionsBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()

        scooterId = intent.extras?.getString("ScooterId")
        if(scooterId == "Wallet"){
            grandTotal = intent.extras?.getString("grandTotal")
        }else{
            subscriptionId = intent.extras?.getString("subscriptionId")
            rideTimeTaken = intent.extras?.getString("rideTimeTaken")
            totalRideRent = intent.extras?.getString("totalRideRent")
            unlockCharge = intent.extras?.getString("unlockCharge")
            totalRent = intent.extras?.getString("totalRent")
            vatCharge = intent.extras?.getString("vatCharge")
            grandTotal = intent.extras?.getString("grandTotal")
        }
        binding.txtAmount.text = "${grandTotal}SAR"
        binding.txtHeader.text = UiUtils.langValue(this,"GENERIC_RECHARGE")
        binding.txtTitle.text = UiUtils.langValue(this,"GENERIC_PAYMENT")
        binding.btnNewCard.text = UiUtils.langValue(this,"GENERIC_ADD_NEW_CARD")
        binding.btnAddedCards.text = UiUtils.langValue(this,"GENERIC_ADDED_CARDS")
        binding.btnPay.text = UiUtils.langValue(this,"GENERIC_PAY")

        var localDb = LocalDatabase.getAppDatabase(this)
        var list = localDb?.appDao()?.cardsList()
        binding.rclCards.layoutManager = LinearLayoutManager(this)
        list?.forEach {
            var cards = Cards().apply {
                cardEntity = it
                expiry = "${UiUtils.langValue(this@RechargeOptionsActivity,"GENERIC_EXPIRES")} on ${it.month}/${it.year.takeLast(2)}"
                number = " ${it.number.takeLast(4)}"
            }
            cardsList.add(cards)
        }
        cardAdapter = CardAdapter(cardsList,this)
        binding.rclCards.adapter = cardAdapter

        binding.btnNewCard.setOnClickListener {
            Intent(this,DebitCardActivity::class.java).apply {
                putExtra("subscriptionId",subscriptionId)
                putExtra("rideTimeTaken",rideTimeTaken)
                putExtra("totalRideRent",totalRideRent)
                putExtra("unlockCharge",unlockCharge)
                putExtra("totalRent",totalRent)
                putExtra("vatCharge",vatCharge)
                putExtra("grandTotal",grandTotal)
                putExtra("ScooterId",scooterId)
            }.also {
                if(scooterId == "Wallet"){
                    startActivityForResult(it,1013)
                }else{
                    startActivity(it)
                }
            }
        }

        binding.imgBack.setOnClickListener {
            finish()
        }

        binding.btnPay.setOnClickListener {
            PaymentConstants.CARD_TYPE = "Debit"

            startActivityForResult(Intent(this, PayActivity::class.java).apply {
                putExtra("cardHolder",selectedCard.cardEntity.name)
                putExtra("cardNumber",selectedCard.cardEntity.number)
                putExtra("expiryMonth",selectedCard.cardEntity.month)
                putExtra("expiryYear",selectedCard.cardEntity.year)
                putExtra("cvv",selectedCard.cardEntity.cvv)
                putExtra("total",grandTotal)
            },1013)
        }
    }

    fun onCardSelect(sCard:Cards,position:Int){
        isCardSelected = true
        selectedCard = sCard
        cardsList.forEachIndexed { index, cards ->
            var card = cards
            card.isSelected = index == position
            cardsList[index] = card
            /*if(sCard.cardEntity.id == cards.cardEntity.id){
                var card = cards
                card.isSelected = true //index == position
                cardsList[index] = card
            }else{
                var card = cards
                card.isSelected = false //index == position
                cardsList[index] = card
            }*/
        }
        cardAdapter.updateList(cardsList)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(requestCode == 1013 && resultCode == Activity.RESULT_OK){
            if(scooterId == "Wallet"){
                val intent = Intent()
                intent.putExtra("statusMessage", data?.extras?.getString("statusMessage"));
                setResult(Activity.RESULT_OK, intent)
                finish()
            }else{
                val debitPaymentRequest = DebitPaymentRequest().apply {
                    id = DevicePreferences.getSharedPreference(this@RechargeOptionsActivity,
                        Constants.USER_ID,
                        SealedPreference.STRING) as String
                    card_holder_name = selectedCard.cardEntity.name
                    card_number = selectedCard.cardEntity.number
                    expire_month = selectedCard.cardEntity.month
                    expire_year = selectedCard.cardEntity.year
                    scootoro_id = scooterId?:""
                    payment_method = "debit"
                    cvv = selectedCard.cardEntity.cvv
                    amount = grandTotal?:""
                    subscription_id=subscriptionId?:""
                    ride_time_taken=rideTimeTaken?:""
                    total_ride_rent=totalRideRent?:""
                    unlock_charge=unlockCharge?:""
                    total_rent=totalRent?:""
                    vat_charge=vatCharge?:""
                    grand_total=grandTotal?:""
                }
                scProgressDialog.showDialog(this@RechargeOptionsActivity,"Payment in process")
                CoroutineScope(Dispatchers.IO).launch{
                    try {
                        val response = ApiCall.debitCardPayment(debitPaymentRequest)
                        if(response.isSuccessful){
                            if(response.body()?.status == "Success"){
                                val tripDetail = response.body()?.trip_details
                                var localDatabase = LocalDatabase.getAppDatabase(this@RechargeOptionsActivity)
                                var tripEntity = TripEntity().apply {
                                    tripDetail?.let {
                                        tripNo = it.trip_number
                                        customerId = it.customer_id
                                        scooterId = it.scooter_id
                                        paymentId = it.payment_id
                                        rideStart = it.ride_start
                                        tripPaymentType = "Debit"
                                        isRideEnd = false
                                        tripTime = it.ride_mins
                                        paidAmount = totalRideRent.toString()
                                    }
                                }
                                localDatabase?.appDao()?.newTrip(tripEntity)

                                withContext(Dispatchers.Main){
                                    scProgressDialog.dismissDialog()
                                    Intent(this@RechargeOptionsActivity,RidePrePaidActivity::class.java).also {
                                        startActivity(it)
                                    }
                                }
                            }else{
                                withContext(Dispatchers.Main){
                                    scProgressDialog.dismissDialog()
                                    UiUtils.showToast(this@RechargeOptionsActivity,response.body()?.message.toString())
                                }
                            }
                        }else{
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@RechargeOptionsActivity,"Unable to make payment")
                            }
                        }
                    }catch (e:Exception){
                        e.printStackTrace()
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@RechargeOptionsActivity,"Unable to make payment")
                        }
                    }
                }
            }
        }else{
            try{
                val message = data?.extras?.getString("statusMessage");
                UiUtils.showToast(this,message?:"Payment unsuccessful")
            }catch (e:Exception){
                e.printStackTrace()
            }
        }
    }
}