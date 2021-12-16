package com.app.scooteroapp.activities

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.app.scooterapp.activities.DashboardActivity
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.databinding.ActivityLoginBinding
import com.app.scooteroapp.entities.LoginRequest
import com.app.scooteroapp.fragments.ForgotPasswordFragment
import com.app.scooteroapp.fragments.SCProgressDialog
import com.app.scooteroapp.networkcall.ApiCall
import com.app.scooteroapp.utility.UiUtils
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.SignInButton
import com.google.android.gms.common.api.ApiException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext


class LoginActivity : AppCompatActivity() {
    lateinit var binding : ActivityLoginBinding
    lateinit var gso : GoogleSignInOptions
    lateinit var mGoogleSignInClient: GoogleSignInClient
    var scProgressDialog = SCProgressDialog()
    lateinit var activityContext : Context

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityLoginBinding.inflate(layoutInflater)
        setContentView(binding.root)
        activityContext = this
        gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestEmail()
            .build()
        mGoogleSignInClient = GoogleSignIn.getClient(this,gso)
        with(binding){
            txtTitle.text = UiUtils.langValue(activityContext,"GENERIC_LOGIN")
            edtMobNo.hint = UiUtils.langValue(activityContext,"GENERIC_ENTER_MOBILE_NUMBER")
            edtPassword.hint = UiUtils.langValue(activityContext,"GENERIC_PASSWORD")
            btnLogin.text = UiUtils.langValue(activityContext,"GENERIC_LOGIN")
            txtForgotPass.text = UiUtils.langValue(activityContext,"GENERIC_FORGET_PASSWORD")
            txtOr.text = UiUtils.langValue(activityContext,"GENERIC_OR")
            txtRegister.text = UiUtils.langValue(activityContext,"GENERIC_NEW_USER_REGISTER")
            txtChangeLang.text = UiUtils.langValue(activityContext,"GENERIC_CHOOSE_LANGUGAE")
            setGooglePlusButtonText(binding.btnGoogleSignIn,UiUtils.langValue(activityContext,"GENERIC_SIGNIN_GOOGLE"))
        }
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
        binding.txtRegister.setOnClickListener {
            Intent(this,RegistrationActivity::class.java).also {
                startActivity(it)
            }
        }
        binding.txtChangeLang.setOnClickListener {
            Intent(this,LanguageActivity::class.java).apply {
                putExtra("from","changeLang")
            }.also {
                startActivityForResult(it,1000)
            }
        }
        binding.txtForgotPass.setOnClickListener {
            val forgotPass = ForgotPasswordFragment().newInstance()
            forgotPass.setLoginActivity(this)
            forgotPass.show(supportFragmentManager,"forgotPass")
        }
        binding.btnGoogleSignIn.setOnClickListener {
            val intent = mGoogleSignInClient.signInIntent
            startActivityForResult(intent,1001)
        }
        binding.btnLogin.setOnClickListener {
            if(isValid()){
                val loginRequest = LoginRequest().apply {
                    mobile_number = binding.edtMobNo.text.toString()
                    password = binding.edtPassword.text.toString()
                }
                scProgressDialog.showDialog(this,"Please wait while Logging In..")
                CoroutineScope(Dispatchers.IO).launch {
                    try {
                        val response = ApiCall.login(loginRequest)
                        if(response.isSuccessful){
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                if(response.body()?.status == "Success"){
                                    var loginDetails = response.body()?.data?.customer_details
                                    var settingsDetail = response.body()?.data?.settings
                                    DevicePreferences.setSharedPreference(this@LoginActivity,Constants.USER_EMAIL,loginDetails?.email)
                                    DevicePreferences.setSharedPreference(this@LoginActivity,Constants.USER_ID,loginDetails?.id)
                                    DevicePreferences.setSharedPreference(this@LoginActivity,Constants.USER_GENDER,loginDetails?.gender)
                                    DevicePreferences.setSharedPreference(this@LoginActivity,Constants.USER_MOB_NO,loginDetails?.mobile_number)
                                    DevicePreferences.setSharedPreference(this@LoginActivity,Constants.PASSWORD,loginDetails?.plain_password)
                                    DevicePreferences.setSharedPreference(this@LoginActivity,Constants.DOB,loginDetails?.dob)
                                    DevicePreferences.setSharedPreference(this@LoginActivity,Constants.USER_NAME,loginDetails?.name)
                                    DevicePreferences.setSharedPreference(this@LoginActivity,Constants.CONTACT_EMAIL,settingsDetail?.contact_email)
                                    DevicePreferences.setSharedPreference(this@LoginActivity,Constants.UNLOCK_CHARGE,settingsDetail?.unlock_charge)
                                    DevicePreferences.setSharedPreference(this@LoginActivity,Constants.VATT,settingsDetail?.vatt)
                                    DevicePreferences.setSharedPreference(this@LoginActivity,Constants.COPY_RIGTH,settingsDetail?.copy_right)
                                    DevicePreferences.setSharedPreference(this@LoginActivity,Constants.SITE_ADDRESS,settingsDetail?.site_address)
                                    DevicePreferences.setSharedPreference(this@LoginActivity,Constants.IS_LOGGED_IN,true)

                                    Intent(this@LoginActivity, DashboardActivity::class.java).apply {
                                        addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                                        addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                    }.also {
                                       startActivity(it)
                                   }
                                }else{
                                    UiUtils.showToast(this@LoginActivity,response.body()?.message.toString())
                                }
                            }
                        }else{
                            withContext(Dispatchers.Main){
                                scProgressDialog.dismissDialog()
                                UiUtils.showToast(this@LoginActivity,"Unable to login")
                            }
                        }
                    }catch (e:Exception){
                        e.printStackTrace()
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@LoginActivity,"Unable to login")
                        }
                    }
                }
            }
        }
    }

    private fun isValid() : Boolean{
        if(binding.edtMobNo.text.toString().isEmpty()){
            UiUtils.showToast(this,"Enter mobile number")
            return false
        }else if(binding.edtPassword.text.toString().isEmpty()){
            UiUtils.showToast(this,"Enter password")
            return false
        }else if(binding.edtMobNo.text.toString().length < 8){
            UiUtils.showToast(this,"Enter valid mobile number")
            return false
        }
        return true
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(requestCode == 1001 && resultCode == Activity.RESULT_OK){
            val task = GoogleSignIn.getSignedInAccountFromIntent(data)
            val account = task.getResult(ApiException::class.java)
            Log.d("Email",account?.email)
            Log.d("Name",account?.displayName)
            Log.d("Id",account?.id)
          /*  account?.email?.let { Log.d("Email", it) }
            account?.displayName?.let { Log.d("Name", it) }
            account?.id?.let { Log.d("Id", it)*/
            val loginRequest = LoginRequest().apply {
                mobile_number = ""
                password = ""
                isGoogle = true
                googleid = account?.id?:""
            }
            scProgressDialog.showDialog(this,"Please wait while Logging In..")
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val response = ApiCall.login(loginRequest)
                    if(response.isSuccessful){
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            if(response.body()?.status == "Success"){
                                var loginDetails = response.body()?.data?.customer_details
                                var settingsDetail = response.body()?.data?.settings
                                DevicePreferences.setSharedPreference(this@LoginActivity,Constants.USER_EMAIL,loginDetails?.email)
                                DevicePreferences.setSharedPreference(this@LoginActivity,Constants.USER_ID,loginDetails?.id)
                                DevicePreferences.setSharedPreference(this@LoginActivity,Constants.USER_GENDER,loginDetails?.gender)
                                DevicePreferences.setSharedPreference(this@LoginActivity,Constants.USER_MOB_NO,loginDetails?.mobile_number)
                                DevicePreferences.setSharedPreference(this@LoginActivity,Constants.PASSWORD,loginDetails?.plain_password)
                                DevicePreferences.setSharedPreference(this@LoginActivity,Constants.DOB,loginDetails?.dob)
                                DevicePreferences.setSharedPreference(this@LoginActivity,Constants.USER_NAME,loginDetails?.name)
                                DevicePreferences.setSharedPreference(this@LoginActivity,Constants.CONTACT_EMAIL,settingsDetail?.contact_email)
                                DevicePreferences.setSharedPreference(this@LoginActivity,Constants.UNLOCK_CHARGE,settingsDetail?.unlock_charge)
                                DevicePreferences.setSharedPreference(this@LoginActivity,Constants.VATT,settingsDetail?.vatt)
                                DevicePreferences.setSharedPreference(this@LoginActivity,Constants.COPY_RIGTH,settingsDetail?.copy_right)
                                DevicePreferences.setSharedPreference(this@LoginActivity,Constants.SITE_ADDRESS,settingsDetail?.site_address)
                                DevicePreferences.setSharedPreference(this@LoginActivity,Constants.IS_LOGGED_IN,true)

                                Intent(this@LoginActivity,DashboardActivity::class.java).apply {
                                    addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                                    addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                }.also {
                                    startActivity(it)
                                }
                            }else{
                                UiUtils.showToast(this@LoginActivity,response.body()?.message.toString())
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main){
                            scProgressDialog.dismissDialog()
                            UiUtils.showToast(this@LoginActivity,"Unable to login")
                        }
                    }
                }catch (e:Exception){
                    e.printStackTrace()
                    withContext(Dispatchers.Main){
                        scProgressDialog.dismissDialog()
                        UiUtils.showToast(this@LoginActivity,"Unable to login")
                    }
                }
            }
        }else if(requestCode == 1000 && resultCode == Activity.RESULT_OK){
            with(binding){
                txtTitle.text = UiUtils.langValue(activityContext,"GENERIC_LOGIN")
                edtMobNo.hint = UiUtils.langValue(activityContext,"GENERIC_ENTER_MOBILE_NUMBER")
                edtPassword.hint = UiUtils.langValue(activityContext,"GENERIC_PASSWORD")
                btnLogin.text = UiUtils.langValue(activityContext,"GENERIC_LOGIN")
                txtForgotPass.text = UiUtils.langValue(activityContext,"GENERIC_FORGET_PASSWORD")
                txtOr.text = UiUtils.langValue(activityContext,"GENERIC_OR")
                txtRegister.text = UiUtils.langValue(activityContext,"GENERIC_NEW_USER_REGISTER")
                txtChangeLang.text = UiUtils.langValue(activityContext,"GENERIC_CHOOSE_LANGUGAE")
                setGooglePlusButtonText(binding.btnGoogleSignIn,UiUtils.langValue(activityContext,"GENERIC_SIGNIN_GOOGLE"))
            }
        }
    }
}