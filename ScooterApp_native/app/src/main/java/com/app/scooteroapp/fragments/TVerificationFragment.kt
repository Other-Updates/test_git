package com.app.scooteroapp.fragments

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.app.scooteroapp.R
import com.app.scooteroapp.databinding.FragmentTutorialBinding
import com.app.scooteroapp.utility.UiUtils

class TVerificationFragment : Fragment() {

    lateinit var binding : FragmentTutorialBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentTutorialBinding.inflate(inflater,container,false)
        binding.txtTitle.text = UiUtils.langValue(context,"GENERIC_VERIFICATION")
        binding.txtDesc.text = UiUtils.langValue(context,"GENERIC_VERIFICATION_CONTENT")
        binding.imageView3.setImageResource(R.drawable.bg_verification)
        return binding.root
    }
}