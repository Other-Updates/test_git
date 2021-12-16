package com.app.scooteroapp.fragments

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.app.scooteroapp.R
import com.app.scooteroapp.activities.*
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.constants.SealedPreference
import com.app.scooteroapp.databinding.FragmentScanResultBinding
import com.app.scooteroapp.entities.UnlockScooterResponse
import com.app.scooteroapp.utility.UiUtils
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialogFragment

class ScanResultFragment(var scooterDetail: UnlockScooterResponse.UnlockScooterDetail?) : BottomSheetDialogFragment() {

    override fun getTheme(): Int = R.style.BottomSheetDialogTheme
    lateinit var activity : Activity
    lateinit var binding : FragmentScanResultBinding
    var position = 0

    fun newInstance(scooterDetail: UnlockScooterResponse.UnlockScooterDetail?): ScanResultFragment {
        return ScanResultFragment(scooterDetail)
    }

    fun setScanActivity(scanActivity: Activity){
        this.activity = scanActivity
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
        binding = FragmentScanResultBinding.inflate(inflater,container,false)
        binding.rlUnlockScooter.setOnClickListener {
            val paymentMethod = DevicePreferences.getSharedPreference(activity,Constants.PAYMENT_METHOD,SealedPreference.STRING) as String
            if(paymentMethod.isEmpty()){
                Intent(activity,PaymentMethodActivity::class.java).apply { putExtra("ScooterId",scooterDetail?.scooter_id) }.also { startActivity(it) }
            }else if(paymentMethod == Constants.PAYMENT_CREDIT){
                if(activity is ManualBarcodeActivity){
                    (activity as ManualBarcodeActivity).onCreditCardUnlock()
                    dismiss()
                }
            }else if(paymentMethod == Constants.PAYMENT_DEBIT){
                Intent(activity,ChooseRiderPlanActivity::class.java).apply { putExtra("ScooterId",scooterDetail?.scooter_id) }.also {
                    startActivity(it)
                    activity.finish()
                }
            }
        }
        binding.txtScooterId.text = UiUtils.langValue(context,"GENERIC_SCOOTERO") + " " + scooterDetail?.serial_number
        binding.txtBatteryPercent.text = UiUtils.langValue(context,"GENERIC_BATTERY") + " " + scooterDetail?.battery_life
        binding.txtUnlock.text = UiUtils.langValue(context,"GENERIC_UNLOCK_SCOOTER")
        return binding.root
    }
}