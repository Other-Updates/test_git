package com.app.scooteroapp.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.app.scooteroapp.databinding.RowWalletItemBinding
import com.app.scooteroapp.entities.DebitedDetailsResponse
import java.text.SimpleDateFormat

class DebitedDetailsAdapter(var DebitedList:ArrayList<DebitedDetailsResponse.Data>) : RecyclerView.Adapter<DebitedDetailsAdapter.DebitedDetailsViewHolder>() {

    class DebitedDetailsViewHolder(var binding : RowWalletItemBinding) : RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): DebitedDetailsViewHolder {
        var binding = RowWalletItemBinding.inflate(LayoutInflater.from(parent.context),parent,false)
        return DebitedDetailsViewHolder(binding)
    }

    override fun getItemCount(): Int {
        return DebitedList.size
    }

    override fun onBindViewHolder(holder: DebitedDetailsViewHolder, position: Int) {
        holder.binding.txtTitle.text = DebitedList[position].pay_description
        holder.binding.txtAmount.text = "${DebitedList[position].amount}SAR"
        var outputFormat = SimpleDateFormat("dd MMM yyyy")
        var inputFormat = SimpleDateFormat("dd/MM/yyyy")
        var outputDate = ""
        try {
            var inputDate = inputFormat.parse(DebitedList[position].created_date)
            outputDate = outputFormat.format(inputDate)
        }catch (e:Exception){
            e.printStackTrace()
        }
        holder.binding.txtDate.text = outputDate
    }
}