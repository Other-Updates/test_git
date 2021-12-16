package com.app.scooteroapp.fragments

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.fragment.app.Fragment
import com.app.scooteroapp.R
import com.app.scooteroapp.activities.LoginActivity
import com.app.scooteroapp.activities.TutorialActivity
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.databinding.FragmentTloginBinding
import com.app.scooteroapp.utility.UiUtils
import com.google.android.gms.common.SignInButton


class TLoginFragment: Fragment() {
    lateinit var binding : FragmentTloginBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentTloginBinding.inflate(inflater,container,false)
        (activity as TutorialActivity).binding.btnSkip.visibility = View.GONE
        (activity as TutorialActivity).binding.vwFooter.visibility = View.GONE
        (activity as TutorialActivity).binding.viewPagerIndicator.visibility = View.GONE
        val btn = binding.loginLayout.findViewById<SignInButton>(R.id.btnGoogleSignIn)
        binding.loginLayout.findViewById<TextView>(R.id.txtTitle).text = UiUtils.langValue(requireContext(),"GENERIC_LOGIN")
        binding.loginLayout.findViewById<EditText>(R.id.edtMobNo).hint = UiUtils.langValue(requireContext(),"GENERIC_ENTER_MOBILE_NUMBER")
        binding.loginLayout.findViewById<EditText>(R.id.edtPassword).hint = UiUtils.langValue(requireContext(),"GENERIC_PASSWORD")
        binding.loginLayout.findViewById<Button>(R.id.btnLogin).text = UiUtils.langValue(requireContext(),"GENERIC_LOGIN")
        binding.loginLayout.findViewById<TextView>(R.id.txtForgotPass).text = UiUtils.langValue(requireContext(),"GENERIC_FORGET_PASSWORD")
        binding.loginLayout.findViewById<TextView>(R.id.txtOr).text = UiUtils.langValue(requireContext(),"GENERIC_OR")
        binding.loginLayout.findViewById<TextView>(R.id.txtRegister).text = UiUtils.langValue(requireContext(),"GENERIC_NEW_USER_REGISTER")
        setGooglePlusButtonText(btn, UiUtils.langValue(requireContext(),"GENERIC_SIGNIN_GOOGLE"))

        return binding.root
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

    override fun setUserVisibleHint(visible: Boolean) {
        super.setUserVisibleHint(visible)
        if (visible && isResumed) {
            onResume()
        }
    }

    override fun onResume() {
        super.onResume()
        if (!userVisibleHint) {
            return
        }
        Intent(activity,LoginActivity::class.java).apply {
            setFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION)
        }.also {
            DevicePreferences.setSharedPreference(requireContext(), Constants.IS_TUTORIAL,true)
            startActivity(it)
            activity?.finish()
        }
    }
}