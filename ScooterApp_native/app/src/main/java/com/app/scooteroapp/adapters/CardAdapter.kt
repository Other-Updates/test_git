package com.app.scooteroapp.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.app.scooteroapp.activities.RechargeOptionsActivity
import com.app.scooteroapp.databinding.RowCardItemBinding
import com.app.scooteroapp.entities.Cards

class CardAdapter(var list : ArrayList<Cards>,var activity:RechargeOptionsActivity) : RecyclerView.Adapter<CardAdapter.CardViewHolder>() {

    class CardViewHolder(var binding : RowCardItemBinding) : RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CardViewHolder {
        var binding = RowCardItemBinding.inflate(LayoutInflater.from(parent.context),parent,false)
        return CardViewHolder(binding)
    }

    override fun getItemCount(): Int {
        return list.size
    }

    override fun onBindViewHolder(holder: CardViewHolder, position: Int) {
        holder.binding.txtCardNo.text = list[position].number
        holder.binding.txtExpiry.text = list[position].expiry
        holder.binding.rdCard.isChecked = list[position].isSelected
        holder.binding.crdCard.setOnClickListener {
            activity.onCardSelect(list[position],position)
        }
    }

    fun updateList(updatedList:ArrayList<Cards>){
        this.list = updatedList
        notifyDataSetChanged()
    }
}