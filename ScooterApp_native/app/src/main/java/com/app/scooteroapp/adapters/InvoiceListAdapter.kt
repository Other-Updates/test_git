package com.app.scooteroapp.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.app.scooteroapp.activities.InvoiceListActivity
import com.app.scooteroapp.databinding.RowInvoiceItemBinding
import com.app.scooteroapp.entities.InvoiceListResponse

class InvoiceListAdapter(var list:ArrayList<InvoiceListResponse.Invoice>,var activity:InvoiceListActivity) : RecyclerView.Adapter<InvoiceListAdapter.InvoiceListViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): InvoiceListViewHolder {
        val binding = RowInvoiceItemBinding.inflate(LayoutInflater.from(parent.context),parent,false)
        return InvoiceListViewHolder(binding)
    }

    override fun getItemCount(): Int {
        return list.size
    }

    override fun onBindViewHolder(holder: InvoiceListViewHolder, position: Int) {
        val invoice = list[position]
        with(holder.binding){
            txtRideNo.text = invoice.trip_number
            txtAmount.text = "${invoice.amount}SAR"
            txtDate.text = invoice.date

            clInvoiceItem.setOnClickListener{
                activity.onInvoiceSelect(invoice)
            }
        }
    }

    class InvoiceListViewHolder(var binding:RowInvoiceItemBinding) : RecyclerView.ViewHolder(binding.root)
}