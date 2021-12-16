package com.app.scooteroapp.payment;


public interface PaymentStatusRequestListener {

    void onErrorOccurred();
    void onPaymentStatusReceived(String paymentStatus);
}
