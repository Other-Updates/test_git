package com.app.scooteroapp.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.DialogFragment
import com.app.scooteroapp.R
import com.app.scooteroapp.databinding.FragmentGenderBinding
import com.app.scooteroapp.databinding.FragmentScanResultBinding
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialogFragment

class GenderFragment(var genderClick : ((value:String,view:DialogFragment)->Unit)? = null) : BottomSheetDialogFragment() {

    override fun getTheme(): Int = R.style.BottomSheetDialogTheme
    lateinit var binding : FragmentGenderBinding

    fun newInstance(): GenderFragment {
        return GenderFragment()
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
        binding = FragmentGenderBinding.inflate(inflater,container,false)
        binding.txtMale.setOnClickListener { genderClick?.invoke("Male",this@GenderFragment) }
        binding.txtFemale.setOnClickListener { genderClick?.invoke("Female",this@GenderFragment) }
        return binding.root
    }
}