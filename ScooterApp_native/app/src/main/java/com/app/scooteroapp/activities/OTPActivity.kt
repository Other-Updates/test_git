package com.app.scooteroapp.activities

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.CountDownTimer
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.ActivityOTPBinding
import com.app.scooteroapp.entities.*
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.UiUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class OTPActivity : AppCompatActivity() {
    lateinit var binding : ActivityOTPBinding
    private var otp : String? = ""
    private var fromScreen:String?=""
    var scProgressDialog = SCProgressDialog()
    private var customerId : String?=""
    private var mobileNo:String? = ""
    private var email:String? = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityOTPBinding.inflate(layoutInflater)
        setContentView(binding.root)
        otp = intent.extras?.getString("OTP")
        fromScreen = intent.extras?.getString("From")
        if(intent.hasExtra("customerId")){
            customerId = intent.extras?.getString("customerId")
        }else{
            customerId = DevicePreferences.getSharedPreference(this,Constants.USER_ID,SealedPreference.STRING) as String
        }
        if(intent.hasExtra("mobileNo")){
            mobileNo = intent.extras?.getString("mobileNo")
        }
        if(intent.hasExtra("email")){
            email = intent.extras?.getString("email")
        }

        binding.textView2.text = UiUtils.langValue(this,"GENERIC_OTP_VERIFY")
        binding.btnVerify.text = UiUtils.langValue(this,"GENERIC_VERIFY")
        binding.txtOr.text = UiUtils.langValue(this,"GENERIC_OR")
        binding.txtChangeNo.text = UiUtils.langValue(this,"GENERIC_CHANGE_MOBILE_NUMBER")
        binding.txtResend.text = UiUtils.langValue(this@OTPActivity,"GENERIC_OTP_RESEND")
        initListeners()
        initTimer()
    }

    private fun initListeners(){
        with(binding){
            txtResend.setOnClickListener {
                //resendForgetOTP()
                resendOTP()
            }

            btnVerify.setOnClickListener {
                val enteredOTP = "${editTextNumber1.text}" +
                        "${editTextNumber2.text}" +
                        "${editTextNumber3.text}" +
                        "${editTextNumber4.text}"
                if(enteredOTP.length < 4){
                    UiUtils.showToast(this@OTPActivity,"Enter valid OTP")
                }else{
                    if(fromScreen == Constants.OTP_FORGOT_PASS_TYPE){
                        forgetPassReq(enteredOTP)
                    }else{
                        loginReq(enteredOTP)
                    }
                }
            }
        }

        binding.txtChangeNo.setOnClickListener {
            Intent(this,ChangeMobileNumberActivity::class.java).apply {
                putExtra("From",fromScreen)
                putExtra("customerId",customerId)
            }.also {
                startActivity(it)
            }
        }

        binding.editTextNumber1.addTextChangedListener(object:TextWatcher{
            override fun afterTextChanged(p0: Editable?) {

            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {

            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if(p0?.length == 1){
                    binding.editTextNumber2.requestFocus()
                }
            }
        })

        binding.editTextNumber2.addTextChangedListener(object:TextWatcher{
            override fun afterTextChanged(p0: Editable?) {
                if(p0?.length == 0){
                    binding.editTextNumber1.requestFocus()
                }
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {

            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if(p0?.length == 1){
                    binding.editTextNumber3.requestFocus()
                }else{
                    binding.editTextNumber1.requestFocus()
                }
            }
        })

        binding.editTextNumber3.addTextChangedListener(object:TextWatcher{
            override fun afterTextChanged(p0: Editable?) {
                if(p0?.length == 0){
                    binding.editTextNumber2.requestFocus()
                }
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {

            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if(p0?.length == 1){
                    binding.editTextNumber4.requestFocus()
                }else{
                    binding.editTextNumber2.requestFocus()
                }
            }
        })

        binding.editTextNumber4.addTextChangedListener(object:TextWatcher{
            override fun afterTextChanged(p0: Editable?) {
                if(p0?.length == 0){
                    binding.editTextNumber3.requestFocus()
                }
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {

            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if(p0?.length == 0){
                    binding.editTextNumber3.requestFocus()
                }
            }
        })
    }

    private fun resendOTP(){
        if(fromScreen == "ChangeNumber"){
            val customerId = DevicePreferences.getSharedPreference(this@OTPActivity,Constants.USER_ID,SealedPreference.STRING) as String
            val existingNumber = DevicePreferences.getSharedPreference(this@OTPActivity,Constants.USER_MOB_NO,SealedPreference.STRING) as String
            val generateOTPRequest = GenerateOTPRequest(customerId,"change mobile",
                    existingNumber,existingNumber)
            scProgressDialog.showDialog(this@OTPActivity,"Please wait while resending OTP..")
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val response = ApiCall.generateOTP(generateOTPRequest)
                    if(response.isSuccessful){
                        if(response.body()?.status == "Success"){
                            otp = response.body()?.OTP
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                binding.txtResend.isEnabled = true
                                initTimer()
                                binding.txtResend.visibility = View.GONE
                            }
                            /*val otpReq = DashboardRequest(customerId)
                            val otpRes = ApiCall.sendOTP(otpReq)
                            if(otpRes.isSuccessful){

                            }*/
                        }else{
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@OTPActivity,"Unable to resend OTP")
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@OTPActivity,"Unable to resend OTP")
                        }
                    }
                }catch (e: java.lang.Exception){
                    e.printStackTrace()
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@OTPActivity,"Unable to resend OTP")
                    }
                }
            }
        }else if(fromScreen == "ChangeEmail"){
            val customerId = DevicePreferences.getSharedPreference(this@OTPActivity,Constants.USER_ID,SealedPreference.STRING) as String
            val existingNumber = DevicePreferences.getSharedPreference(this@OTPActivity,Constants.USER_MOB_NO,SealedPreference.STRING) as String
            val existingEmail = DevicePreferences.getSharedPreference(this@OTPActivity,Constants.USER_EMAIL,SealedPreference.STRING) as String
            val generateOTPRequest = GenerateOTPRequest(customerId,"change email",
                    existingEmail,existingNumber)
            scProgressDialog.showDialog(this@OTPActivity,"Please wait while resending OTP..")
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val response = ApiCall.generateOTP(generateOTPRequest)
                    if(response.isSuccessful){
                        if(response.body()?.status == "Success"){
                            otp = response.body()?.OTP
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                binding.txtResend.isEnabled = true
                                initTimer()
                                binding.txtResend.visibility = View.GONE
                            }
                            /*val otpReq = DashboardRequest(customerId)
                            val otpRes = ApiCall.sendOTP(otpReq)
                            if(otpRes.isSuccessful){

                            }*/
                        }else{
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@OTPActivity,"Unable to resend OTP")
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@OTPActivity,"Unable to resend OTP")
                        }
                    }
                }catch (e: java.lang.Exception){
                    e.printStackTrace()
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@OTPActivity,"Unable to resend OTP")
                    }
                }
            }
        }else{
            scProgressDialog.showDialog(this@OTPActivity,"Please wait resending OTP..")
            val forgetRequest = ForgotRequest(mobileNo!!)
            CoroutineScope(Dispatchers.IO).launch {
                val response = ApiCall.forgotPassword(forgetRequest)
                if(response.isSuccessful){
                    if(response.body()?.status == "Success"){
                        val generateOTPRequest = GenerateOTPRequest(response.body()?.data?.id!!,"forget password",
                                mobileNo!!,mobileNo!!)
                        /*val otpReq = DashboardRequest(response.body()?.data?.id!!)
                        val otpRes = ApiCall.sendOTP(otpReq)*/
                        val otpRes= ApiCall.generateOTP(generateOTPRequest)
                        if(otpRes.isSuccessful){
                            otp = otpRes.body()?.OTP
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                binding.txtResend.isEnabled = true
                                initTimer()
                                binding.txtResend.visibility = View.GONE
                            }
                        }else{
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@OTPActivity,"Error sending OTP")
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@OTPActivity,response.body()?.message.toString())
                        }
                    }
                }else{
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@OTPActivity,"Error verifying mobile number")
                    }
                }
            }
        }
    }
    
    private fun resendForgetOTP(){
        binding.txtResend.isEnabled = false
        CoroutineScope(Dispatchers.IO).launch {
            val otpReq = DashboardRequest(customerId!!)
            val otpRes = ApiCall.sendOTP(otpReq)
            if(otpRes.isSuccessful){
                otp = otpRes.body()?.OTP
                withContext(Dispatchers.Main){
                    binding.txtResend.isEnabled = true
                    initTimer()
                    binding.txtResend.visibility = View.GONE
                }
            }else{
                withContext(Dispatchers.Main){
                    binding.txtResend.isEnabled = true
                }
            }
        }
    }

    private fun forgetPassReq(enteredOTP: String){
        scProgressDialog.showDialog(this@OTPActivity,"Verifying OTP..")
//        val request = CheckOTPRequest(customerId!!,enteredOTP)
        val request = UpdateOTPRequest(customerId!!,"forget password",mobileNo!!,mobileNo!!,otp!!)
        CoroutineScope(Dispatchers.IO).launch {
            try{
                val response = ApiCall.checkOTP(request)
                if(response.isSuccessful){
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        if(response.body()?.status == "Success"){
                            var loginDetails = response.body()?.data?.customer_details
                            var settingsDetail = response.body()?.data?.settings
                            DevicePreferences.setSharedPreference(this@OTPActivity,
                                Constants.USER_EMAIL,loginDetails?.email)
                            DevicePreferences.setSharedPreference(this@OTPActivity,
                                Constants.USER_ID,loginDetails?.id)
                            DevicePreferences.setSharedPreference(this@OTPActivity,
                                Constants.USER_GENDER,loginDetails?.gender)
                            DevicePreferences.setSharedPreference(this@OTPActivity,
                                Constants.USER_MOB_NO,loginDetails?.mobile_number)
                            DevicePreferences.setSharedPreference(this@OTPActivity,
                                Constants.PASSWORD,loginDetails?.plain_password)
                            DevicePreferences.setSharedPreference(this@OTPActivity,
                                Constants.DOB,loginDetails?.dob)
                            DevicePreferences.setSharedPreference(this@OTPActivity,
                                Constants.USER_NAME,loginDetails?.name)
                            DevicePreferences.setSharedPreference(this@OTPActivity,
                                Constants.CONTACT_EMAIL,settingsDetail?.contact_email)
                            DevicePreferences.setSharedPreference(this@OTPActivity,
                                Constants.UNLOCK_CHARGE,settingsDetail?.unlock_charge)
                            DevicePreferences.setSharedPreference(this@OTPActivity,
                                Constants.VATT,settingsDetail?.vatt)
                            DevicePreferences.setSharedPreference(this@OTPActivity,
                                Constants.COPY_RIGTH,settingsDetail?.copy_right)
                            DevicePreferences.setSharedPreference(this@OTPActivity,
                                Constants.SITE_ADDRESS,settingsDetail?.site_address)
                            DevicePreferences.setSharedPreference(this@OTPActivity,
                                Constants.IS_LOGGED_IN,true)

                            Intent(this@OTPActivity,ResetpassActivity::class.java).apply {
                                putExtra("OTPStatus",enteredOTP == otp)
                                putExtra("From",fromScreen)
                                UiUtils.showToast(this@OTPActivity,"OTP verified Successfully")
                            }.also {
                                startActivity(it)
                            }
                        }else{
                            Intent(this@OTPActivity,ResetpassActivity::class.java).apply {
                                putExtra("OTPStatus",false)
                                putExtra("From",fromScreen)
                            }.also {
                                startActivity(it)
                            }
                        }
                    }
                }else{
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        Intent(this@OTPActivity,ResetpassActivity::class.java).apply {
                            putExtra("OTPStatus",false)
                            putExtra("From",fromScreen)
                        }.also {
                            startActivity(it)
                        }
                    }
                }
            }catch (e:Exception){
                e.printStackTrace()
                withContext(Dispatchers.Main){
                    scProgressDialog.dismissDialog()
                    UiUtils.showToast(this@OTPActivity,"Unable to login")
                }
            }
        }
    }

    private fun loginReq(enteredOTP:String){
        var progMsg = if(fromScreen == "ChangeNumber" || fromScreen == "ChangeEmail"){
            "Please wait while verifying OTP..."
        }else{
            "Please wait while Logging In.."
        }
        scProgressDialog.showDialog(this@OTPActivity,progMsg)
        val id = DevicePreferences.getSharedPreference(this,Constants.USER_ID,SealedPreference.STRING) as String
        val existingNumber = DevicePreferences.getSharedPreference(this,Constants.USER_MOB_NO,SealedPreference.STRING) as String
        if(fromScreen == "ChangeNumber"  || fromScreen == "ChangeEmail"){
            CoroutineScope(Dispatchers.IO).launch {
                var updateRequest = if(fromScreen == "ChangeNumber"){
                    UpdateOTPRequest(id,"change mobile",mobileNo?:"",existingNumber,otp?:"")
                }else{
                    UpdateOTPRequest(id,"change email",email?:"",existingNumber,otp?:"")
                }
                val response = ApiCall.updateOTP(updateRequest)
                if(response.isSuccessful){
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        if(response.body()?.status == "Success"){
                            if(fromScreen == "ChangeNumber"){
                                DevicePreferences.setSharedPreference(this@OTPActivity,Constants.USER_MOB_NO,mobileNo)
                            }else{
                                DevicePreferences.setSharedPreference(this@OTPActivity,Constants.USER_EMAIL,email)
                            }
                            Intent(this@OTPActivity,OTPAckActivity::class.java).apply {
                                putExtra("OTPStatus",enteredOTP == otp)
                                putExtra("From",fromScreen)
                            }.also {
                                startActivity(it)
                            }
                        }else{
                            UiUtils.showToast(this@OTPActivity,response.body()?.message.toString())
                        }
                    }
                }else{
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@OTPActivity,"Unable to change mobile number")
                    }
                }
            }
        }else{
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    var mobNo = ""
                    if(Constants.loginRequest.mobile_number.isEmpty()){
                        mobNo = mobileNo!!
                    }else{
                        mobNo = Constants.loginRequest.mobile_number
                    }
                    val response = ApiCall.registerCheckOTP(CheckRegisterOTPRequest(enteredOTP,"",mobNo))
                    if(response.isSuccessful){
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            if(response.body()?.status == "Success"){
                                var loginDetails = response.body()?.data?.customer_details
                                var settingsDetail = response.body()?.data?.settings
                                DevicePreferences.setSharedPreference(this@OTPActivity, Constants.USER_EMAIL,loginDetails?.email)
                                DevicePreferences.setSharedPreference(this@OTPActivity, Constants.USER_ID,loginDetails?.id)
                                DevicePreferences.setSharedPreference(this@OTPActivity,
                                    Constants.USER_GENDER,loginDetails?.gender)
                                DevicePreferences.setSharedPreference(this@OTPActivity,
                                    Constants.USER_MOB_NO,loginDetails?.mobile_number)
                                DevicePreferences.setSharedPreference(this@OTPActivity,
                                    Constants.PASSWORD,loginDetails?.plain_password)
                                DevicePreferences.setSharedPreference(this@OTPActivity,
                                    Constants.DOB,loginDetails?.dob)
                                DevicePreferences.setSharedPreference(this@OTPActivity,
                                    Constants.USER_NAME,loginDetails?.name)
                                DevicePreferences.setSharedPreference(this@OTPActivity,
                                    Constants.CONTACT_EMAIL,settingsDetail?.contact_email)
                                DevicePreferences.setSharedPreference(this@OTPActivity,
                                    Constants.UNLOCK_CHARGE,settingsDetail?.unlock_charge)
                                DevicePreferences.setSharedPreference(this@OTPActivity,
                                    Constants.VATT,settingsDetail?.vatt)
                                DevicePreferences.setSharedPreference(this@OTPActivity,
                                    Constants.COPY_RIGTH,settingsDetail?.copy_right)
                                DevicePreferences.setSharedPreference(this@OTPActivity,
                                    Constants.SITE_ADDRESS,settingsDetail?.site_address)
                                DevicePreferences.setSharedPreference(this@OTPActivity,
                                    Constants.IS_LOGGED_IN,true)

                                Intent(this@OTPActivity,OTPAckActivity::class.java).apply {
                                    putExtra("OTPStatus",enteredOTP == otp)
                                    putExtra("From",fromScreen)
                                }.also {
                                    startActivity(it)
                                }
                            }else{
                                UiUtils.showToast(this@OTPActivity,response.body()?.message.toString())
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@OTPActivity,"Unable to login")
                        }
                    }
                }catch (e:Exception){
                    e.printStackTrace()
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@OTPActivity,"Unable to login")
                    }
                }
            }
        }
    }

    private fun initTimer(){
        var timeValue = 30
        binding.txtTimer.visibility = View.VISIBLE
        binding.txtResend.visibility = View.GONE

        val timer = object: CountDownTimer(30000,1000){
            override fun onFinish() {
                binding.txtTimer.text = "(00:30)"
                binding.txtTimer.visibility = View.GONE
                binding.txtResend.visibility = View.VISIBLE
                binding.btnVerify.isEnabled = true
            }

            override fun onTick(p0: Long) {
                timeValue = timeValue.minus(1)
                binding.txtTimer.text = "(00:${timeValue})"
                binding.btnVerify.isEnabled = true
            }
        }
        timer.start()
    }
}