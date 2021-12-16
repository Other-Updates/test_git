package com.app.scooteroapp.activities

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.Spannable
import android.text.SpannableString
import android.text.TextPaint
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.view.View
import com.app.scooterapp.activities.DashboardActivity
import com.app.scooteroapp.R
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.databinding.ActivityAcknowledgementBinding
import com.app.scooteroapp.utility.UiUtils

class AcknowledgementActivity : AppCompatActivity() {
    lateinit var binding : ActivityAcknowledgementBinding
    var ackType:String? = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityAcknowledgementBinding.inflate(layoutInflater)
        setContentView(binding.root)

        ackType = intent.extras?.getString(Constants.ACK_TYPE)

        when(ackType){
            Constants.ACK_UPDATE_PROFILE->{
                binding.txtAck.text = getString(R.string.ack_update_profile)
                binding.imgAck.setImageResource(R.drawable.update_profile_success)
            }
            Constants.ACK_RIDE_COMPLETE->{
                var message = UiUtils.langValue(this,"GENERIC_RIDE_COMPLETE_MSG")
                var spannableString = SpannableString(message)
                spannableString.setSpan(object:ClickableSpan(){
                    override fun onClick(p0: View) {
                        Intent(this@AcknowledgementActivity,InvoiceListActivity::class.java).also {
                            startActivity(it)
                            finish()
                        }
                    }
                    override fun updateDrawState(ds: TextPaint) {
                        super.updateDrawState(ds)
                        ds.isUnderlineText = false
                        ds.linkColor = resources.getColor(R.color.green,null)
                    }
                },message.length-16,message.length-9,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
                binding.txtAck.text = spannableString
                binding.txtAck.movementMethod = LinkMovementMethod.getInstance()
                binding.imgAck.setImageResource(R.drawable.update_profile_success)
            }
        }

        binding.imgClose.setOnClickListener {
            if(ackType == Constants.ACK_UPDATE_PROFILE){
                finish()
            }else if(ackType == Constants.ACK_RIDE_COMPLETE){
                Intent(this, DashboardActivity::class.java).also {
                    startActivity(it)
                    finish()
                }
            }
        }
    }
}