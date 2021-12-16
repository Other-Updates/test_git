package com.app.scooteroapp.payment;

public interface PayResult {
    void onPaidResult(boolean status,String statusMessage);
}
