package com.app.scooteroapp.activities

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.app.scooterapp.activities.DashboardActivity
import com.app.scooteroapp.R
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityFeedbackBinding
import com.app.scooteroapp.entities.FeedbackRequest
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class FeedbackActivity : AppCompatActivity() {
    lateinit var binding : ActivityFeedbackBinding
    private var serverTripId : String? = ""
    private var scooterId : String? = ""
    private var scProgressDialog = SCProgressDialog()
    lateinit var activityContext : Context

    var isWont = false
    var isJerky = false
    var isSlow = false
    var isDamaged = false
    var isDirty = false
    var choice = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityFeedbackBinding.inflate(layoutInflater)
        setContentView(binding.root)
        activityContext = this
        serverTripId = intent.extras?.getString("serverTripId")
        scooterId = intent.extras?.getString("ScooterId")

        with(binding){
            txtTitle.text = UiUtils.langValue(activityContext,"GENERIC_HOW_ENJOY_RIDE")
            textView3.text = UiUtils.langValue(activityContext,"GENERIC_PROVIDE_FEEDBACK")
            edtFeedback.hint = UiUtils.langValue(activityContext,"GENERIC_ENTER_FEEDBACK")
            btnSubmit.text = UiUtils.langValue(activityContext,"GENERIC_SUBMIT")
            btnWont.text = UiUtils.langValue(activityContext,"GENERIC_WONT_START")
            btnJerky.text = UiUtils.langValue(activityContext,"GENERIC_JERKY")
            btnSlow.text = UiUtils.langValue(activityContext,"GENERIC_SLOW")
            btnDamaged.text = UiUtils.langValue(activityContext,"GENERIC_DEMAGED")
        }

        binding.ratingBar.setOnRatingBarChangeListener { ratingBar, fl, b ->
            if(fl < 5f){
                binding.llOne.visibility = View.VISIBLE
                binding.llTwo.visibility = View.VISIBLE
            }else{
                choice = ""
                binding.llOne.visibility = View.GONE
                binding.llTwo.visibility = View.GONE
            }
        }
        binding.btnWont.setOnClickListener {
            choice = "Won't Start"
            isWont = true
            isJerky = false
            isSlow = false
            isDamaged = false
            isDirty = false
            updateChoice()
        }
        binding.btnJerky.setOnClickListener {
            choice = "Jerky"
            isWont = false
            isJerky = true
            isSlow = false
            isDamaged = false
            isDirty = false
            updateChoice()
        }
        binding.btnSlow.setOnClickListener {
            choice = "Slow"
            isWont = false
            isJerky = false
            isSlow = true
            isDamaged = false
            isDirty = false
            updateChoice()
        }
        binding.btnDamaged.setOnClickListener {
            choice = "Damaged"
            isWont = false
            isJerky = false
            isSlow = false
            isDamaged = true
            isDirty = false
            updateChoice()
        }
        binding.btnDirty.setOnClickListener {
            choice = "Dirty"
            isWont = false
            isJerky = false
            isSlow = false
            isDamaged = false
            isDirty = true
            updateChoice()
        }

        binding.btnSubmit.setOnClickListener {
            val feedBackRequest = FeedbackRequest().apply {
                scootoro_id = scooterId?:""
                trip_id = serverTripId?:""
                id = DevicePreferences.getSharedPreference(this@FeedbackActivity,Constants.USER_ID,SealedPreference.STRING) as String
                feedback = binding.edtFeedback.text.toString()
                ratings = binding.ratingBar.rating.toString()
            }
            scProgressDialog.showDialog(this,"Submitting feedback")
            CoroutineScope(Dispatchers.IO).launch {
                try{
                    val response = ApiCall.rideFeedBack(feedBackRequest)
                    if(response.isSuccessful){
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@FeedbackActivity,response.body()?.message.toString())
                            if(response.body()?.status == "Success"){
                                Intent(this@FeedbackActivity,AcknowledgementActivity::class.java).apply {
                                    putExtra(Constants.ACK_TYPE,Constants.ACK_RIDE_COMPLETE)
                                }.also {
                                    startActivity(it)
                                    finish()
                                }
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@FeedbackActivity,"Unable to submit feedback")
                        }
                    }
                }catch (e:Exception){
                    e.printStackTrace()
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@FeedbackActivity,"Unable to submit feedback")
                    }
                }
            }
        }
        binding.btnClose.setOnClickListener {
            Intent(this, DashboardActivity::class.java).also {
                startActivity(it)
                finish()
            }
        }
    }

    fun updateChoice(){
        if(isWont){
            binding.btnWont.setBackgroundResource(R.drawable.bg_feedback_select)
            binding.btnWont.setTextColor(resources.getColor(R.color.feedback_select,null))
        }else{
            binding.btnWont.setBackgroundResource(R.drawable.bg_feedback_unselect)
            binding.btnWont.setTextColor(resources.getColor(R.color.feedback_unselect,null))
        }

        if(isJerky){
            binding.btnJerky.setBackgroundResource(R.drawable.bg_feedback_select)
            binding.btnJerky.setTextColor(resources.getColor(R.color.feedback_select,null))
        }else{
            binding.btnJerky.setBackgroundResource(R.drawable.bg_feedback_unselect)
            binding.btnJerky.setTextColor(resources.getColor(R.color.feedback_unselect,null))
        }

        if(isSlow){
            binding.btnSlow.setBackgroundResource(R.drawable.bg_feedback_select)
            binding.btnSlow.setTextColor(resources.getColor(R.color.feedback_select,null))
        }else{
            binding.btnSlow.setBackgroundResource(R.drawable.bg_feedback_unselect)
            binding.btnSlow.setTextColor(resources.getColor(R.color.feedback_unselect,null))
        }

        if(isDamaged){
            binding.btnDamaged.setBackgroundResource(R.drawable.bg_feedback_select)
            binding.btnDamaged.setTextColor(resources.getColor(R.color.feedback_select,null))
        }else{
            binding.btnDamaged.setBackgroundResource(R.drawable.bg_feedback_unselect)
            binding.btnDamaged.setTextColor(resources.getColor(R.color.feedback_unselect,null))
        }

        if(isDirty){
            binding.btnDirty.setBackgroundResource(R.drawable.bg_feedback_select)
            binding.btnDirty.setTextColor(resources.getColor(R.color.feedback_select,null))
        }else{
            binding.btnDirty.setBackgroundResource(R.drawable.bg_feedback_unselect)
            binding.btnDirty.setTextColor(resources.getColor(R.color.feedback_unselect,null))
        }
    }
}