package com.app.scooteroapp.fragments

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.app.scooteroapp.R
import android.widget.FrameLayout
import com.app.scooteroapp.activities.LoginActivity
import com.app.scooteroapp.activities.OTPActivity
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.databinding.FragmentForgotPasswordBinding
import com.app.scooteroapp.entities.ForgotRequest
import com.app.scooteroapp.entities.GenerateOTPRequest
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.UiUtils
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext


class ForgotPasswordFragment : BottomSheetDialogFragment() {

    override fun getTheme(): Int = R.style.BottomSheetDialogTheme
    lateinit var activity : LoginActivity
    lateinit var binding : FragmentForgotPasswordBinding
    var position = 0

    fun newInstance(): ForgotPasswordFragment {
        return ForgotPasswordFragment()
    }

    fun setLoginActivity(activity : LoginActivity){
        this.activity = activity
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        view.viewTreeObserver.addOnGlobalLayoutListener{
            val bDialog = dialog
            val bSheet = dialog?.findViewById<FrameLayout>(com.google.android.material.R.id.design_bottom_sheet)
            val behavior = BottomSheetBehavior.from(bSheet)
            behavior.state = BottomSheetBehavior.STATE_EXPANDED
            behavior.peekHeight = 0
        }
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        binding = FragmentForgotPasswordBinding.inflate(inflater,container,false)
        with(binding){
            textView4.text = UiUtils.langValue(context,"GENERIC_FORGET_PASSWORD")
            btnSubmit.text = UiUtils.langValue(context,"GENERIC_FORGET_GENERATE_OTP")
            edtMobNo.hint = UiUtils.langValue(context,"GENERIC_ENTER_MOBILE_NUMBER")

            btnSubmit.setOnClickListener {
                if(edtMobNo.text.toString().isEmpty()){
                    UiUtils.showToast(activity,UiUtils.langValue(context,"GENERIC_ENTER_MOBILE_NUMBER"))
                }else{
                    activity.scProgressDialog.showDialog(activity,"Please wait while verifying mobile number..")
                    val forgetRequest = ForgotRequest(edtMobNo.text.toString())
                    CoroutineScope(Dispatchers.IO).launch {
                        val response = ApiCall.forgotPassword(forgetRequest)
                        if(response.isSuccessful){
                            if(response.body()?.status == "Success"){
                                val generateOTPRequest = GenerateOTPRequest(response.body()?.data?.id!!,"forget password",
                                        edtMobNo.text.toString(),edtMobNo.text.toString())
                                /*val otpReq = DashboardRequest(response.body()?.data?.id!!)
                                val otpRes = ApiCall.sendOTP(otpReq)*/
                                val otpRes= ApiCall.generateOTP(generateOTPRequest)
                                if(otpRes.isSuccessful){
                                    withContext(Dispatchers.Main){
                                       // activity.scProgressDialog.dismissDialog()
                                        Intent(activity, OTPActivity::class.java).apply {
                                            putExtra("OTP",otpRes.body()?.OTP)
                                            putExtra("From", Constants.OTP_FORGOT_PASS_TYPE)
                                            putExtra("customerId",response.body()?.data?.id)
                                            putExtra("mobileNo",edtMobNo.text.toString())
                                        }.also {
                                            activity.startActivity(it)
                                        }
                                    }
                                }else{
                                    withContext(Dispatchers.Main){
                                        activity.scProgressDialog.dismissDialog()
                                        UiUtils.showToast(activity,"Error verifying mobile number")
                                    }
                                }
                            }else{
                                withContext(Dispatchers.Main){
                                    activity.scProgressDialog.dismissDialog()
                                    UiUtils.showToast(activity,response.body()?.message.toString())
                                }
                            }
                        }else{
                            withContext(Dispatchers.Main){
                                activity.scProgressDialog.dismissDialog()
                                UiUtils.showToast(activity,"Error verifying mobile number")
                            }
                        }
                    }
                }
            }
        }
        return binding.root
    }
}