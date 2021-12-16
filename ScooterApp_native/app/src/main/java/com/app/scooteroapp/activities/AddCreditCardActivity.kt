package com.app.scooteroapp.activities

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityAddCreditCardBinding
import com.app.scooteroapp.entities.CreditCardPaymentRequest
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.payment.PayActivity
import com.app.scooteroapp.payment.PaymentConstants
import com.app.scooteroapp.room.CardEntity
import com.app.scooteroapp.room.LocalDatabase
import com.app.scooteroapp.room.TripEntity
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.*

class AddCreditCardActivity : AppCompatActivity() {
    lateinit var binding : ActivityAddCreditCardBinding
    private var scooterId:String?=null
    private var scProgressDialog = SCProgressDialog()
    lateinit var activityContext:Context

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityAddCreditCardBinding.inflate(layoutInflater)
        setContentView(binding.root)
        activityContext = this
        supportActionBar?.hide()
        with(binding){
            txtHeader.text = UiUtils.langValue(activityContext,"GENERIC_ADD_CC")
            txtTitle.text = UiUtils.langValue(activityContext,"GENERIC_CARD_NAME")
            edtName.hint = UiUtils.langValue(activityContext,"GENERIC_CARD_NAME_PRINT")
            txtCardNo.text = UiUtils.langValue(activityContext,"GENERIC_CARD_NUMBER")
            txtExpiry.text = UiUtils.langValue(activityContext,"GENERIC_EXPIRY")
            txtCvv.text = UiUtils.langValue(activityContext,"GENERIC_CVV")
            btnAdd.text = UiUtils.langValue(activityContext,"GENERIC_ADD")
        }
        scooterId = intent.extras?.getString("ScooterId")

        initListeners()
    }


    private fun initListeners(){
        binding.imgBack.setOnClickListener { finish() }

        binding.btnAdd.setOnClickListener {
            if(isValid()){
                DevicePreferences.setSharedPreference(this@AddCreditCardActivity,Constants.PAYMENT_METHOD,Constants.PAYMENT_CREDIT)
                var cardEntity = CardEntity().apply {
                    name = binding.edtName.text.toString()
                    number = "${binding.edtCardNo1.text.toString()}${binding.edtCardNo2.text.toString()}${binding.edtCardNo3.text.toString()}${binding.edtCardNo4.text.toString()}"
                    month = binding.edtMonth.text.toString()
                    year = "20${binding.edtYear.text.toString()}"
                    type = "Credit"
                    cvv = binding.edtCvv.text.toString()
                }
                var localDatabase = LocalDatabase.getAppDatabase(this@AddCreditCardActivity)
                val cards = localDatabase?.appDao()?.cardsList()
                var duplicateResult = false
                cards?.forEach {
                    if(it.number == cardEntity.number){
                        UiUtils.showToast(this,"Card already exists")
                        duplicateResult = true
                    }
                }
                if(duplicateResult){
                    return@setOnClickListener
                }
                localDatabase?.appDao()?.newCard(cardEntity)

                PaymentConstants.CARD_TYPE = "Credit"

                startActivityForResult(Intent(this,PayActivity::class.java).apply {
                    putExtra("cardHolder",binding.edtName.text.toString())
                    putExtra("cardNumber",cardEntity.number)
                    putExtra("expiryMonth",cardEntity.month)
                    putExtra("expiryYear",cardEntity.year)
                    putExtra("cvv",binding.edtCvv.toString())
                    putExtra("total","20")
                },1012)
            }
        }

        binding.edtCardNo1.addTextChangedListener(object: TextWatcher {
            override fun afterTextChanged(p0: Editable?) {

            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {

            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if(p0?.length == 4){
                    binding.edtCardNo2.requestFocus()
                }
            }
        })

        binding.edtCardNo2.addTextChangedListener(object: TextWatcher {
            override fun afterTextChanged(p0: Editable?) {

            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {

            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if(p0?.length == 4){
                    binding.edtCardNo3.requestFocus()
                }
            }
        })

        binding.edtCardNo3.addTextChangedListener(object: TextWatcher {
            override fun afterTextChanged(p0: Editable?) {

            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {

            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if(p0?.length == 4){
                    binding.edtCardNo4.requestFocus()
                }
            }
        })

        binding.edtCardNo4.addTextChangedListener(object: TextWatcher {
            override fun afterTextChanged(p0: Editable?) {

            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {

            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if(p0?.length == 4){
                    binding.edtMonth.requestFocus()
                }
            }
        })

        binding.edtMonth.addTextChangedListener(object: TextWatcher {
            override fun afterTextChanged(p0: Editable?) {

            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {

            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if(p0?.length == 2){
                    binding.edtYear.requestFocus()
                }
            }
        })

        binding.edtYear.addTextChangedListener(object: TextWatcher {
            override fun afterTextChanged(p0: Editable?) {

            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {

            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if(p0?.length == 2){
                    binding.edtCvv.requestFocus()
                }
            }
        })
    }

    private fun isValid():Boolean{
        val calendar = Calendar.getInstance()
        val year = calendar.get(Calendar.YEAR)
        with(binding){
            val cardNo = "${edtCardNo1.text.toString()}${edtCardNo2.text.toString()}${edtCardNo3.text.toString()}${edtCardNo4.text.toString()}"
            if(edtName.text.toString().isEmpty()){
                UiUtils.showToast(this@AddCreditCardActivity,"Enter name on card")
                return false
            }else if(cardNo.length < 16){
                UiUtils.showToast(this@AddCreditCardActivity,"Enter valid card number")
                return false
            }else if(edtMonth.text.toString().isEmpty()){
                UiUtils.showToast(this@AddCreditCardActivity,"Enter expiry month")
                return false
            }else if(Integer.parseInt(edtMonth.text.toString()) < 1 || Integer.parseInt(edtMonth.text.toString()) > 12){
                UiUtils.showToast(this@AddCreditCardActivity,"Enter valid valid expiry month")
                return false
            }else if(edtYear.text.toString().isEmpty()){
                UiUtils.showToast(this@AddCreditCardActivity,"Enter expiry year")
                return false
            }else if(Integer.parseInt(edtYear.text.toString()) < Integer.parseInt(year.toString().takeLast(2))){
                UiUtils.showToast(this@AddCreditCardActivity,"Enter valid expiry year")
                return false
            }else if(edtCvv.text.toString().isEmpty()){
                UiUtils.showToast(this@AddCreditCardActivity,"Enter cvv")
                return false
            }else if(edtCvv.text.toString().length < 3){
                UiUtils.showToast(this@AddCreditCardActivity,"Enter valid cvv")
                return false
            }
            return true
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(requestCode == 1012 && resultCode == Activity.RESULT_OK){
            if(scooterId == "Wallet"){
                val intent = Intent()
                intent.putExtra("statusMessage", data?.extras?.getString("statusMessage"));
                setResult(Activity.RESULT_OK, intent)
                finish()
            }else{
                val creditCardPaymentRequest = CreditCardPaymentRequest().apply {
                    id = DevicePreferences.getSharedPreference(this@AddCreditCardActivity,Constants.USER_ID,SealedPreference.STRING) as String
                    card_holder_name = binding.edtName.text.toString()
                    card_number = "${binding.edtCardNo1.text.toString()}${binding.edtCardNo2.text.toString()}${binding.edtCardNo3.text.toString()}${binding.edtCardNo4.text.toString()}"
                    expire_month = binding.edtMonth.text.toString()
                    expire_year = "20${binding.edtYear.text.toString()}"
                    scootoro_id = scooterId?:""
                    payment_method = "credit"
                    cvv = binding.edtCvv.text.toString()
                    amount = "100"
                }
                scProgressDialog.showDialog(this@AddCreditCardActivity,"Payment in process")
                CoroutineScope(Dispatchers.IO).launch{
                    try {
                        val response = ApiCall.creditCardPayment(creditCardPaymentRequest)
                        if(response.isSuccessful){
                            val tripDetail = response.body()?.trip_details
                            if(response.body()?.status == "Success"){
                                /*                    DevicePreferences.setSharedPreference(this@AddCreditCardActivity,Constants.PAYMENT_METHOD,Constants.PAYMENT_CREDIT)
                                                    var cardEntity = CardEntity().apply {
                                                        name = binding.edtName.text.toString()
                                                        number = "${binding.edtCardNo1.text.toString()}${binding.edtCardNo2.text.toString()}${binding.edtCardNo3.text.toString()}${binding.edtCardNo4.text.toString()}"
                                                        month = binding.edtMonth.text.toString()
                                                        year = "20${binding.edtYear.text.toString()}"
                                                        type = "Credit"
                                                    }*/
                                var localDatabase = LocalDatabase.getAppDatabase(this@AddCreditCardActivity)
                                /*localDatabase?.appDao()?.newCard(cardEntity)*/
                                var tripEntity = TripEntity().apply {
                                    tripDetail?.let {
                                        tripNo = it.trip_number
                                        customerId = it.customer_id
                                        scooterId = it.scooter_id
                                        paymentId = it.payment_id
                                        rideStart = it.ride_start
                                        tripPaymentType = "Credit"
                                        isRideEnd = false
                                    }
                                }
                                localDatabase?.appDao()?.newTrip(tripEntity)

                                withContext(Dispatchers.Main){
                                    scProgressDialog.dismissDialog()
                                    Intent(this@AddCreditCardActivity,RidePostPaidActivity::class.java).also {
                                        startActivity(it)
                                    }
                                }
                            }else{
                                withContext(Dispatchers.Main){
                                    scProgressDialog.dismissDialog()
                                    UiUtils.showToast(this@AddCreditCardActivity,response.body()?.message.toString())
                                }
                            }
                        }else{
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@AddCreditCardActivity,"Unable to make payment")
                            }
                        }
                    }catch (e:Exception){
                        e.printStackTrace()
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@AddCreditCardActivity,"Unable to make payment")
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