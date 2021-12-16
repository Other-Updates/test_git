package com.app.scooteroapp.activities

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentPagerAdapter
import com.app.scooteroapp.constants.Constants
import com.app.scooteroapp.constants.DevicePreferences
import com.app.scooteroapp.databinding.ActivityTutorialBinding
import com.app.scooteroapp.fragments.*


class TutorialActivity : AppCompatActivity() {
    lateinit var binding : ActivityTutorialBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityTutorialBinding.inflate(layoutInflater)
        setContentView(binding.root)

        var list = ArrayList<Fragment>()
        list.add(TRegistrationFragment())
        list.add(TVerificationFragment())
        list.add(TPaymentsFragment())
        list.add(TUnlockFragment())
        list.add(TRideFragment())
        list.add(TLoginFragment())
        val pagerAdapter = PagerAdapter(supportFragmentManager,list)
        binding.viewPager.adapter = pagerAdapter

        binding.btnSkip.setOnClickListener {
            DevicePreferences.setSharedPreference(this,Constants.IS_TUTORIAL,true)
            Intent(this,LoginActivity::class.java).also {
                startActivity(it)
                finish()
            }
        }
    }

    private class PagerAdapter(fragmentManager: FragmentManager,var list:ArrayList<Fragment>) :
        FragmentPagerAdapter(fragmentManager) {
        override fun getCount(): Int {
            return list.size
        }

        override fun getItem(position: Int): Fragment {
            return list[position]
        }
    }

    override fun onPause() {
        super.onPause()
        overridePendingTransition(0, 0)
    }
}