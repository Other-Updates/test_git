package com.app.scooteroapp.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.app.scooteroapp.activities.ChooseRiderPlanActivity
import com.app.scooteroapp.databinding.RowRidePlanFooterItemBinding
import com.app.scooteroapp.databinding.RowRidePlanItemBinding
import com.app.scooteroapp.entities.Subscriptions
import com.app.scooteroapp.utility.UiUtils

class SubscriptionsAdapter(var list : ArrayList<Subscriptions>,var activity:ChooseRiderPlanActivity) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        if(viewType == 0){
            var binding = RowRidePlanItemBinding.inflate(LayoutInflater.from(parent.context),parent,false)
            return SubscriptionHeaderViewHolder(binding)
        }else{
            var binding = RowRidePlanFooterItemBinding.inflate(LayoutInflater.from(parent.context),parent,false)
            return SubscriptionFooterViewHolder(binding)
        }
    }

    override fun getItemCount(): Int {
        return list.size
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        var subscription = list[position]
        if(subscription.type == "Header"){
            (holder as SubscriptionHeaderViewHolder)
            holder.binding.txtPlanTime.text = "${subscription.subscriptionDetail.mins} Minutes"
            holder.binding.txtPlanAmount.text = "${subscription.subscriptionDetail.amount}SAR"
            holder.binding.rdPlan.isChecked = subscription.isSelected
            holder.binding.crdPlan.setOnClickListener {
                activity.selectSubscription(subscription.subscriptionDetail,position)
            }
        }else{
            holder as SubscriptionFooterViewHolder
            with(holder.binding){
                txtRideRentValue.text = "${subscription.totalRideRent}SAR"
                txtUnlockChargeValue.text = "${subscription.unlockCharge}SAR"
                txtSubTotalValue.text = "${subscription.subTotal}SAR"
                txtVatValue.text = "${subscription.vat}SAR"
                txtGrandTotalValue.text = "${subscription.grandTotal}SAR"
                btnSubmit.setOnClickListener { activity.pay() }
                txtTotRideRent.text = UiUtils.langValue(activity,"GENERIC_TOTAL_RIDE_RENT")
                txtUnlockCharge.text = UiUtils.langValue(activity,"GENERIC_UNLOCK_CHARGE")
                txtSubTotal.text = UiUtils.langValue(activity,"GENERIC_SUB_TOTAL")
                txtVat.text = UiUtils.langValue(activity,"GENERIC_VAT")
                txtGrandTotal.text = UiUtils.langValue(activity,"GENERIC_GRAND_TOTAL")
                btnSubmit.text = UiUtils.langValue(activity,"GENERIC_PAY")
            }
        }
    }

    fun updateList(updatedList:ArrayList<Subscriptions>){
        this.list = updatedList
        notifyDataSetChanged()
    }

    override fun getItemViewType(position: Int): Int {
        if(list[position].type == "Header"){
            return 0
        }else{
            return 1
        }
    }

    class SubscriptionHeaderViewHolder(var binding : RowRidePlanItemBinding) : RecyclerView.ViewHolder(binding.root)
    class SubscriptionFooterViewHolder(var binding : RowRidePlanFooterItemBinding) : RecyclerView.ViewHolder(binding.root)
}