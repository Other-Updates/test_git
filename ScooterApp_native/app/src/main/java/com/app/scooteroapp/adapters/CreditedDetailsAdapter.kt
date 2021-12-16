package com.app.scooteroapp.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.app.scooteroapp.databinding.RowWalletItemBinding
import com.app.scooteroapp.entities.CreditedDetailsResponse
import java.text.SimpleDateFormat

class CreditedDetailsAdapter(var creditList:ArrayList<CreditedDetailsResponse.Data>) : RecyclerView.Adapter<CreditedDetailsAdapter.CreditedDetailsViewHolder>() {

    class CreditedDetailsViewHolder(var binding : RowWalletItemBinding) : RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CreditedDetailsViewHolder {
        var binding = RowWalletItemBinding.inflate(LayoutInflater.from(parent.context),parent,false)
        return CreditedDetailsViewHolder(binding)
    }

    override fun getItemCount(): Int {
        return creditList.size
    }

    override fun onBindViewHolder(holder: CreditedDetailsViewHolder, position: Int) {
        holder.binding.txtTitle.text = creditList[position].pay_description
        holder.binding.txtAmount.text = "${creditList[position].amount}SAR"
        var outputFormat = SimpleDateFormat("dd MMM yyyy")
        var inputFormat = SimpleDateFormat("dd/MM/yyyy")
        var outputDate = ""
        try {
            var inputDate = inputFormat.parse(creditList[position].created_date)
            outputDate = outputFormat.format(inputDate)
        }catch (e:Exception){
            e.printStackTrace()
        }
        holder.binding.txtDate.text = outputDate
    }
}