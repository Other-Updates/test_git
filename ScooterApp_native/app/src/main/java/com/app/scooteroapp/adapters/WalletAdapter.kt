package com.app.scooteroapp.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.app.scooteroapp.databinding.RowWalletItemBinding
import com.app.scooteroapp.entities.WalletResponse
import java.text.SimpleDateFormat

class WalletAdapter(var walletList:ArrayList<WalletResponse.WalletDetails>) : RecyclerView.Adapter<WalletAdapter.WalletViewHolder>() {

    class WalletViewHolder(var binding : RowWalletItemBinding) : RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): WalletViewHolder {
        var binding = RowWalletItemBinding.inflate(LayoutInflater.from(parent.context),parent,false)
        return WalletViewHolder(binding)
    }

    override fun getItemCount(): Int {
        return walletList.size
    }

    override fun onBindViewHolder(holder: WalletViewHolder, position: Int) {
        holder.binding.txtTitle.text = walletList[position].type
        holder.binding.txtAmount.text = "${walletList[position].amount}SAR"
        var outputFormat = SimpleDateFormat("dd MMM yyyy")
        var inputFormat = SimpleDateFormat("dd/MM/yyyy")
        var outputDate = ""
        try {
            var inputDate = inputFormat.parse(walletList[position].created_date)
            outputDate = outputFormat.format(inputDate)
        }catch (e:Exception){
            e.printStackTrace()
        }
        holder.binding.txtDate.text = outputDate
    }
}