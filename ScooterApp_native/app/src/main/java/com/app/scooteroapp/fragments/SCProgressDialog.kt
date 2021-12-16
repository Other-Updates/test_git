package com.app.scooteroapp.fragments

import android.graphics.PorterDuff
import android.widget.ProgressBar
import android.app.Activity
import android.view.Gravity
import android.graphics.drawable.ColorDrawable
import android.app.ProgressDialog
import android.content.Context
import android.graphics.Color
import android.view.Window
import android.widget.TextView
import androidx.core.content.ContextCompat.getColor
import com.app.scooteroapp.R
import pl.droidsonroids.gif.GifImageView
import java.util.*


class SCProgressDialog {

    var progress: ProgressDialog? = null
        private set
    private val TAG = this@SCProgressDialog.javaClass.simpleName
    var random = Random()

    fun dismissDialog() {
        try {
            if (progress != null && progress!!.isShowing)
                progress!!.dismiss()
            progress = null
        } catch (e: Exception) {
        }

    }

    fun showDialog(context: Context,message:String) {
        try {
            if (progress != null && progress!!.isShowing) {
                return
            }
            progress = null
            progress = ProgressDialog(context)
            progress?.requestWindowFeature(Window.FEATURE_NO_TITLE)
            progress?.window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
            progress?.window?.setGravity(Gravity.CENTER_HORIZONTAL)

            if (!(context as Activity).isDestroyed) {
                progress?.show()
            }

            val spinner = ProgressBar(context)
            spinner.indeterminateDrawable.setColorFilter(getColor(context, R.color.colorAccent), PorterDuff.Mode.SRC_IN)
            progress?.setContentView(R.layout.layout_custom_progress)
            //progress!!.setContentView(spinner)
            val imgAnim = progress?.findViewById<GifImageView>(R.id.imgAnim)
            var text = progress?.findViewById<TextView>(R.id.txtMessage)
            text?.text = message

            when(random.nextInt(2)){
                1->imgAnim?.setImageResource(R.drawable.anim_scooter_1)
                else->imgAnim?.setImageResource(R.drawable.anim_scooter_2)
            }
            /*when(random.nextInt(8 - 1) + 1){
                1->{
                    imgAnim?.setImageResource(R.drawable.ex_1)
                }
                2->{
                    imgAnim?.setImageResource(R.drawable.ex_2)
                }
                3->{
                    imgAnim?.setImageResource(R.drawable.ex_3)
                }
                4->{
                    imgAnim?.setImageResource(R.drawable.ex_4)
                }
                5->{
                    imgAnim?.setImageResource(R.drawable.ex_5)
                }
                6->{
                    imgAnim?.setImageResource(R.drawable.ex_6)
                }
                7->{
                    imgAnim?.setImageResource(R.drawable.ex_7)
                }
                else->{
                    imgAnim?.setImageResource(R.drawable.ex_8)
                }
            }*/
            // progress.setMessage("Loading...");
            progress?.setCancelable(false)
            progress?.setCanceledOnTouchOutside(false)
            // progress.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
        } catch (e: Exception) {
            e.printStackTrace()
        }

    }
}