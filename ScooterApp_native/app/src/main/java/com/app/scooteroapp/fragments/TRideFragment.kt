package com.app.scooteroapp.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.app.scooteroapp.R
import com.app.scooteroapp.databinding.FragmentTutorialBinding
import com.app.scooteroapp.utility.UiUtils

class TRideFragment:Fragment() {
    lateinit var binding : FragmentTutorialBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentTutorialBinding.inflate(inflater,container,false)
        binding.txtTitle.text = UiUtils.langValue(context,"GENERIC_RIDE_TIME")
        binding.txtDesc.text = UiUtils.langValue(context,"GENERIC_RIDE_TIME_CONTENT")
        binding.imageView3.setImageResource(R.drawable.bg_ride)
        return binding.root
    }
}