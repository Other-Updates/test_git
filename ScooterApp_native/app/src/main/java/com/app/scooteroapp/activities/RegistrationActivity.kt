package com.app.scooteroapp.activities

import android.app.Activity
import android.app.DatePickerDialog
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.DatePicker
import android.widget.TextView
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProviders
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.databinding.ActivityRegistrationBinding
import com.app.scooteroapp.entities.RegisterRequest
import com.app.scooteroapp.fragments.GenderFragment
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.CommonUtils
import com.app.scooteroapp.utility.UiUtils
import com.app.scooteroapp.viewmodels.RegistrationViewModel
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.SignInButton
import com.google.android.gms.common.api.ApiException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.text.DateFormatSymbols
import java.util.*

class RegistrationActivity : AppCompatActivity() {
    lateinit var binding : ActivityRegistrationBinding
    var mYear = 0
    var mMonth = 0
    var mDay = 0
    lateinit var registrationViewModel: RegistrationViewModel
    var scProgressDialog = SCProgressDialog()
    lateinit var gso : GoogleSignInOptions
    lateinit var mGoogleSignInClient: GoogleSignInClient
    var gMailAccountId = ""
    var gMailId = ""
    var gMailName = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityRegistrationBinding.inflate(layoutInflater)
        setContentView(binding.root)
        registrationViewModel = ViewModelProviders.of(this)[RegistrationViewModel::class.java]

        gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestEmail()
            .build()
        mGoogleSignInClient = GoogleSignIn.getClient(this,gso)

        binding.edtName.hint = UiUtils.langValue(this,"GENERIC_NAME")
        binding.edtMobNo.hint = UiUtils.langValue(this,"GENERIC_NUMBER")
        binding.edtDOB.hint = UiUtils.langValue(this,"GENERIC_DOB")
        binding.edtGender.hint = UiUtils.langValue(this,"GENERIC_GENDER")
        binding.edtEmail.hint = UiUtils.langValue(this,"GENERIC_EMAIL")
        binding.edtPassword.hint = UiUtils.langValue(this,"GENERIC_PASSWORD")
        binding.btnRegister.text = UiUtils.langValue(this,"GENERIC_REGISTER")
        binding.txtLogin.text = UiUtils.langValue(this,"GENERIC_ALREADY_HAVE_ACCOUNT")
        binding.txtRegistration.text = UiUtils.langValue(this,"GENERIC_REGISTRATION_REGISTER")
        binding.txtOr.text = UiUtils.langValue(this,"GENERIC_OR")
        binding.textView4.text = UiUtils.langValue(this,"GENERIC_NUMBER")
        binding.edtGmailMobNo.hint = UiUtils.langValue(this,"GENERIC_NUMBER")
        binding.btnGmailReg.text = UiUtils.langValue(this,"GENERIC_REGISTER")
        binding.txtChangeLang.text = UiUtils.langValue(this,"GENERIC_CHOOSE_LANGUGAE")
        setGooglePlusButtonText(binding.btnGoogleSignIn,UiUtils.langValue(this,"GENERIC_REGISTRATION_GOOGLE"))
        initListeners()
    }

    private fun setGooglePlusButtonText(signInButton: SignInButton, buttonText: String?) {
        for (i in 0 until signInButton.childCount) {
            val v: View = signInButton.getChildAt(i)
            if (v is TextView) {
                val tv = v as TextView
                tv.text = buttonText
                return
            }
        }
    }

    private fun initListeners(){
        binding.txtLogin.setOnClickListener {
            Intent(this,LoginActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            }.also {
                startActivity(it)
                finish()
            }
        }
        binding.btnGoogleSignIn.setOnClickListener {
            val intent = mGoogleSignInClient.signInIntent
            startActivityForResult(intent,1001)
        }
        binding.txtChangeLang.setOnClickListener {
            Intent(this,LanguageActivity::class.java).apply {
                putExtra("from","changeLang")
            }.also {
                startActivityForResult(it,1000)
            }
        }
        binding.edtDOB.setOnClickListener{
            val calendar = Calendar.getInstance()
            mYear = calendar.get(Calendar.YEAR)
            mMonth = calendar.get(Calendar.MONTH)
            mDay = calendar.get(Calendar.DAY_OF_MONTH)
            val datePickerDialog = DatePickerDialog(this,object:DatePickerDialog.OnDateSetListener{
                override fun onDateSet(p0: DatePicker?, year: Int, month: Int, day: Int) {
                    binding.edtDOB.setText("$day ${DateFormatSymbols().shortMonths[month]} $year")
                }
            },mYear,mMonth,mDay)
            datePickerDialog.show()
        }
        binding.edtGender.setOnClickListener {
            val genderFragment = GenderFragment{value,dialog->
                binding.edtGender.setText(value)
                dialog.dismiss()
            }
            genderFragment.show(supportFragmentManager,"gender")
        }
        binding.btnRegister.setOnClickListener {
            if(isValid()){
                var registerRequest = RegisterRequest().apply {
                    name = binding.edtName.text.toString()
                    mobile_number = binding.edtMobNo.text.toString()
                    dob = binding.edtDOB.text.toString()
                    gender = binding.edtGender.text.toString()
                    email = binding.edtEmail.text.toString()
                    password = binding.edtPassword.text.toString()
                }

                val loginReq = RegisterRequest().apply {
                    mobile_number = binding.edtMobNo.text.toString()
                    password = binding.edtPassword.text.toString()
                    email = binding.edtEmail.text.toString()
                }
                Constants.loginRequest = loginReq

                scProgressDialog.showDialog(this,"Please wait while Registering...")
                CoroutineScope(Dispatchers.IO).launch{
                    try {
                        val response = ApiCall.register(registerRequest)
                        if(response.isSuccessful){
                            var body = response.body()
                            if(body?.status?.equals("success",ignoreCase = true) == true){
                                withContext(Dispatchers.Main){
                                    scProgressDialog.dismissDialog()
                                    Intent(this@RegistrationActivity,OTPActivity::class.java).apply {
                                        putExtra("OTP",body.OTP)
                                        putExtra("From","Registration")
                                        putExtra("mobileNo",registerRequest.mobile_number)
                                        putExtra("customerId",response.body()?.customer_id.toString())
                                    }.also {
                                        startActivity(it)
                                    }
                                }
                            }else{
                                withContext(Dispatchers.Main){
                                    scProgressDialog.dismissDialog()
                                    UiUtils.showToast(this@RegistrationActivity,body?.message.toString())
                                }
                            }
                        }else{
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@RegistrationActivity,"Error in registration")
                            }
                        }
                    }catch (e:Exception){
                        e.printStackTrace()
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@RegistrationActivity,"Error in registration")
                        }
                    }
                }
            }
        }

        binding.btnGmailReg.setOnClickListener {

            var registerRequest = RegisterRequest().apply {
                name = gMailName
                mobile_number = ""
                dob = ""
                gender = ""
                email = gMailId
                password = ""
                isGoogle = true
                googleid = gMailAccountId
            }

            val loginReq = RegisterRequest().apply {
                isGoogle = true
                googleid = gMailAccountId
                email = gMailId
            }
            Constants.loginRequest = loginReq

            scProgressDialog.showDialog(this,"Please wait while Registering...")
            CoroutineScope(Dispatchers.IO).launch{
                try {
                    val response = ApiCall.register(registerRequest)
                    if(response.isSuccessful){
                        var body = response.body()
                        if(body?.status?.equals("success",ignoreCase = true) == true){
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                Intent(this@RegistrationActivity,OTPActivity::class.java).apply {
                                    putExtra("OTP",body.OTP)
                                    putExtra("From","Registration")
                                }.also {
                                    startActivity(it)
                                }
                            }
                        }else{
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@RegistrationActivity,body?.message.toString())
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@RegistrationActivity,"Error in registration")
                        }
                    }
                }catch (e:Exception){
                    e.printStackTrace()
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@RegistrationActivity,"Error in registration")
                    }
                }
            }
        }

        binding.rlGmailMobNo.setOnClickListener {

        }
    }

    private fun isValid() : Boolean{
        var isValid = true
        with(binding){
            if(edtName.text.toString().isEmpty()){
                UiUtils.showToast(this@RegistrationActivity,"Enter name")
                isValid = false
                return isValid
            }else if(edtMobNo.text.toString().isEmpty()){
                UiUtils.showToast(this@RegistrationActivity,"Enter mobile number")
                isValid = false
                return isValid
            }else if(edtMobNo.text.toString().length < 10){
                UiUtils.showToast(this@RegistrationActivity,"Enter valid mobile number")
                isValid = false
                return isValid
            }else if(edtDOB.text.toString().isEmpty()){
                UiUtils.showToast(this@RegistrationActivity,"Select date of birth")
                isValid = false
                return isValid
            }else if(edtEmail.text.toString().isEmpty()){
                UiUtils.showToast(this@RegistrationActivity,"Enter email address")
                isValid = false
                return isValid
            }else if(!CommonUtils.isValidEmail(edtEmail.text.toString())){
                UiUtils.showToast(this@RegistrationActivity,"Enter valid email address")
                isValid = false
                return isValid
            }else if(edtPassword.text.toString().isEmpty()){
                UiUtils.showToast(this@RegistrationActivity,"Enter password")
                isValid = false
                return isValid
            }else if(edtPassword.text.toString().length < 6){
                UiUtils.showToast(this@RegistrationActivity,"Password should be minimum 6 letters")
                isValid = false
                return isValid
            }
            return isValid
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(requestCode == 1001 && resultCode == Activity.RESULT_OK){
            val task = GoogleSignIn.getSignedInAccountFromIntent(data)
            val account = task.getResult(ApiException::class.java)

            gMailAccountId = account?.id?:""
            gMailId = account?.email?:""
            gMailName = account?.displayName?:""

            binding.rlGmailMobNo.visibility = View.VISIBLE
        }else if(requestCode == 1000 && resultCode == Activity.RESULT_OK){
            binding.edtName.hint = UiUtils.langValue(this,"GENERIC_NAME")
            binding.edtMobNo.hint = UiUtils.langValue(this,"GENERIC_NUMBER")
            binding.edtDOB.hint = UiUtils.langValue(this,"GENERIC_DOB")
            binding.edtGender.hint = UiUtils.langValue(this,"GENERIC_GENDER")
            binding.edtEmail.hint = UiUtils.langValue(this,"GENERIC_EMAIL")
            binding.edtPassword.hint = UiUtils.langValue(this,"GENERIC_PASSWORD")
            binding.btnRegister.text = UiUtils.langValue(this,"GENERIC_REGISTER")
            binding.txtLogin.text = UiUtils.langValue(this,"GENERIC_ALREADY_HAVE_ACCOUNT")
            binding.txtRegistration.text = UiUtils.langValue(this,"GENERIC_REGISTRATION_REGISTER")
            binding.txtOr.text = UiUtils.langValue(this,"GENERIC_OR")
            binding.textView4.text = UiUtils.langValue(this,"GENERIC_NUMBER")
            binding.edtGmailMobNo.hint = UiUtils.langValue(this,"GENERIC_NUMBER")
            binding.btnGmailReg.text = UiUtils.langValue(this,"GENERIC_REGISTER")
            binding.txtChangeLang.text = UiUtils.langValue(this,"GENERIC_CHOOSE_LANGUGAE")
            setGooglePlusButtonText(binding.btnGoogleSignIn,UiUtils.langValue(this,"GENERIC_REGISTRATION_GOOGLE"))
        }
    }

    override fun onBackPressed() {
        if(binding.rlGmailMobNo.isVisible){
            binding.rlGmailMobNo.visibility = View.GONE
        }else{
            finish()
        }
    }
}