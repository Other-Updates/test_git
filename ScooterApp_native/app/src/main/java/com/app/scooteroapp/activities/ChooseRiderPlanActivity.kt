package com.app.scooteroapp.activities

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.scooteroapp.adapters.SubscriptionsAdapter
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityChooseRiderPlanBinding
import com.app.scooteroapp.entities.GetScootersRequest
import com.app.scooteroapp.entities.SubscriptionResponse
import com.app.scooteroapp.entities.Subscriptions
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class ChooseRiderPlanActivity : AppCompatActivity() {
    lateinit var binding : ActivityChooseRiderPlanBinding
    private var scooterId:String? = ""
    private var scProgressDialog = SCProgressDialog()
    lateinit var subscriptionAdapter : SubscriptionsAdapter
    var list = ArrayList<Subscriptions>()
    var vat_charge:String = ""
    var is_subcription_selected = false
    lateinit var selectedSubscription : SubscriptionResponse.SubscriptionDetail

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityChooseRiderPlanBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()

        binding.txtTitle.text = UiUtils.langValue(this,"GENERIC_CHOOSE_RIDE_PLAN")
        scooterId = intent.extras?.getString("ScooterId")
        binding.imgBack.setOnClickListener { finish() }
        binding.rclRidePlan.layoutManager = LinearLayoutManager(this)
        vat_charge = DevicePreferences.getSharedPreference(this@ChooseRiderPlanActivity,Constants.VATT,SealedPreference.STRING) as String

        initData()
    }

    private fun initData(){
        scProgressDialog.showDialog(this,"Getting subscription details")
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = ApiCall.subscriptions(GetScootersRequest(DevicePreferences.getSharedPreference(this@ChooseRiderPlanActivity,Constants.USER_ID,SealedPreference.STRING) as String))
                if(response.isSuccessful){
                    if(response.body()?.status == "Success"){
                        list = ArrayList<Subscriptions>()
                        response.body()?.subscription_details?.forEach {
                            var subscription = Subscriptions().apply {
                                type = "Header"
                                subscriptionDetail = it
                            }
                            list.add(subscription)
                        }
                        var unlock_charge =DevicePreferences.getSharedPreference(this@ChooseRiderPlanActivity,Constants.UNLOCK_CHARGE,SealedPreference.STRING) as String
                        var subscription = Subscriptions().apply {
                            type = "Footer"
                            totalRideRent="0"
                            unlockCharge= DevicePreferences.getSharedPreference(this@ChooseRiderPlanActivity,Constants.UNLOCK_CHARGE,SealedPreference.STRING) as String
                            subTotal= unlock_charge
                            vat= ((Integer.parseInt(subTotal) / 100) * (Integer.parseInt(vat_charge))).toString()
                            grandTotal= (Integer.parseInt(unlock_charge) + Integer.parseInt(vat)).toString()
                        }
                        list.add(subscription)
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            subscriptionAdapter = SubscriptionsAdapter(list,this@ChooseRiderPlanActivity)
                            binding.rclRidePlan.adapter = subscriptionAdapter
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@ChooseRiderPlanActivity,response.body()?.message.toString())
                        }
                    }
                }else{
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@ChooseRiderPlanActivity,"Unable to fetch subscriptions")
                    }
                }
            }catch (e:Exception){
                e.printStackTrace()
                withContext(Dispatchers.Main){
                    scProgressDialog.dismissDialog()
                    UiUtils.showToast(this@ChooseRiderPlanActivity,"Unable to fetch subscriptions")
                }
            }
        }
    }

    fun selectSubscription(subscriptionDetail: SubscriptionResponse.SubscriptionDetail,position:Int){
        is_subcription_selected = true
        selectedSubscription = subscriptionDetail

        list.forEachIndexed { index, subscriptions ->
            val det = subscriptions
            det.isSelected = index == position
            list[index] = det
        }
        var totalItem = list.last()
        var rideRent = subscriptionDetail.amount
        var unlockCharge = totalItem.unlockCharge
        var subTotal = (rideRent.toDouble()) + (unlockCharge.toDouble())
        var vat = ((subTotal / 100.0) * (vat_charge.toDouble()))
        var grandTotal = subTotal + vat
        totalItem.totalRideRent = rideRent
        totalItem.unlockCharge = unlockCharge
        totalItem.subTotal = subTotal.toString()
        totalItem.vat = vat.toString()
        totalItem.grandTotal = grandTotal.toString()
        list[list.size-1] = totalItem

        subscriptionAdapter.updateList(list)
    }

    fun pay(){
        if (is_subcription_selected){
            val debitCard = DevicePreferences.getSharedPreference(this,Constants.PAYMENT_METHOD,SealedPreference.STRING) as String
            if(debitCard.isEmpty()){
                Intent(this,DebitCardActivity::class.java).apply {
                    putExtra("subscriptionId",selectedSubscription.id)
                    putExtra("rideTimeTaken",selectedSubscription.mins)
                    putExtra("totalRideRent",list.last().totalRideRent)
                    putExtra("unlockCharge",list.last().unlockCharge)
                    putExtra("totalRent",list.last().subTotal)
                    putExtra("vatCharge",list.last().vat)
                    putExtra("grandTotal",list.last().grandTotal)
                    putExtra("ScooterId",scooterId)
                }.also { startActivity(it) }
            }else{
                Intent(this,RechargeOptionsActivity::class.java).apply {
                    putExtra("subscriptionId",selectedSubscription.id)
                    putExtra("rideTimeTaken",selectedSubscription.mins)
                    putExtra("totalRideRent",list.last().totalRideRent)
                    putExtra("unlockCharge",list.last().unlockCharge)
                    putExtra("totalRent",list.last().subTotal)
                    putExtra("vatCharge",list.last().vat)
                    putExtra("grandTotal",list.last().grandTotal)
                    putExtra("ScooterId",scooterId)
                }.also { startActivity(it) }
            }
        }else{
            UiUtils.showToast(this,"Select a subscription plan")
        }
    }
}