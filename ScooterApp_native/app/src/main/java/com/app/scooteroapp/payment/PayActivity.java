package com.app.scooteroapp.payment;

import androidx.appcompat.app.AlertDialog;

import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.ServiceConnection;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.util.Log;

import com.app.scooteroapp.R;
import com.oppwa.mobile.connect.exception.PaymentError;
import com.oppwa.mobile.connect.exception.PaymentException;
import com.oppwa.mobile.connect.payment.BrandsValidation;
import com.oppwa.mobile.connect.payment.CheckoutInfo;
import com.oppwa.mobile.connect.payment.ImagesRequest;
import com.oppwa.mobile.connect.payment.PaymentParams;
import com.oppwa.mobile.connect.payment.card.CardPaymentParams;
import com.oppwa.mobile.connect.provider.Connect;
import com.oppwa.mobile.connect.provider.ITransactionListener;
import com.oppwa.mobile.connect.provider.Transaction;
import com.oppwa.mobile.connect.provider.TransactionType;
import com.oppwa.mobile.connect.service.ConnectService;
import com.oppwa.mobile.connect.service.IProviderBinder;

public class PayActivity extends BasePaymentActivity implements ITransactionListener, PayResult {

    private String checkoutId;
    private String ckId;

    String cardHolder, cardNumber, cardExpiryMonth, cardExpiryYear, cardCVV, total = "";

    private IProviderBinder providerBinder;
    private ServiceConnection serviceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            /* we have a connection to the service */
            providerBinder = (IProviderBinder) service;
            providerBinder.addTransactionListener(PayActivity.this);

            try {
                providerBinder.initializeProvider(Connect.ProviderMode.TEST);
            } catch (PaymentException ee) {
                showErrorDialog(ee.getMessage());
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            providerBinder = null;
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pay);
        getSupportActionBar().setTitle("Payment Gateway");
        cardHolder = getIntent().getExtras().getString("cardHolder");
        cardNumber = getIntent().getExtras().getString("cardNumber");
        cardExpiryMonth = getIntent().getExtras().getString("expiryMonth");
        cardExpiryYear = getIntent().getExtras().getString("expiryYear");
        cardCVV = getIntent().getExtras().getString("cvv");
        total = getIntent().getExtras().getString("total");

        PaymentConstants.payResult = this;
        if (total.contains(".")) {
            total = total + "0";
        } else {
            total = total + ".00";
        }
        PaymentConstants.Config.AMOUNT = total;

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                runOnUiThread(() -> {
                    if (providerBinder != null) {
                        requestCheckoutId(getString(R.string.custom_ui_callback_scheme));
                    }
                });
            }
        }, 2000);
    }

    @Override
    public void onCheckoutIdReceived(String checkoutId) {
        super.onCheckoutIdReceived(checkoutId);

        if (checkoutId != null) {
            this.checkoutId = checkoutId;

            requestCheckoutInfo(checkoutId);
        }
    }

    private void requestCheckoutInfo(String checkoutId) {
        if (providerBinder != null) {
            try {
                providerBinder.requestCheckoutInfo(checkoutId);
                showProgressDialog(R.string.progress_message_checkout_info);
            } catch (PaymentException e) {
                showAlertDialog(e.getMessage());
            }
        }
    }

    private void pay(String checkoutId) {
        try {
            PaymentParams paymentParams = createPaymentParams(checkoutId);
            paymentParams.setShopperResultUrl(getString(R.string.custom_ui_callback_scheme) + "://callback");
            Transaction transaction = new Transaction(paymentParams);
            providerBinder.submitTransaction(transaction);
            showProgressDialog(R.string.progress_message_processing_payment);
        } catch (PaymentException e) {
            showErrorDialog(e.getError());
        }
    }

    private PaymentParams createPaymentParams(String checkoutId) throws PaymentException {
        return new CardPaymentParams(
                checkoutId,
                PaymentConstants.Config.CARD_BRAND,
                cardNumber,
                cardHolder,
                cardExpiryMonth,
//                "20" + cardExpiryYear,
                cardExpiryYear,
                cardCVV
        );
    }

    @Override
    public void brandsValidationRequestSucceeded(BrandsValidation brandsValidation) {

    }

    @Override
    public void brandsValidationRequestFailed(PaymentError paymentError) {

    }

    @Override
    public void imagesRequestSucceeded(ImagesRequest imagesRequest) {

    }

    @Override
    public void imagesRequestFailed() {

    }

    @Override
    public void paymentConfigRequestSucceeded(final CheckoutInfo checkoutInfo) {
        hideProgressDialog();

        if (checkoutInfo == null) {
            showErrorDialog(getString(R.string.error_message));

            return;
        }

        /* Get the resource path from checkout info to request the payment status later. */
        resourcePath = checkoutInfo.getResourcePath();
        pay(checkoutId);
        /*runOnUiThread(new Runnable() {
            @Override
            public void run() {
                showConfirmationDialog(
                        String.valueOf(total),
                        "SAR"
                );
            }
        });*/
    }

    private void showConfirmationDialog(String amount, String currency) {
        new AlertDialog.Builder(this)
                .setMessage(String.format(getString(R.string.message_payment_confirmation), amount, currency))
                .setPositiveButton(R.string.button_ok, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        pay(checkoutId);
                    }
                })
                .setNegativeButton(R.string.button_cancel, null)
                .setCancelable(false)
                .show();
    }

    @Override
    public void paymentConfigRequestFailed(PaymentError paymentError) {
        hideProgressDialog();
        showErrorDialog(paymentError);
    }

    @Override
    public void transactionCompleted(Transaction transaction) {
        hideProgressDialog();

        if (transaction == null) {
            showErrorDialog(getString(R.string.error_message));

            return;
        }

        if (transaction.getTransactionType() == TransactionType.SYNC) {
            /* check the status of synchronous transaction */
            requestPaymentStatus(resourcePath);
        } else {
            /* wait for the callback in the onNewIntent() */
            showProgressDialog(R.string.progress_message_please_wait);
            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(transaction.getRedirectUrl())));
         //   Log.d("success","paymentstatus"+transaction);
            // startActivity(new Intent(this, PaymentGatewayActivity.class));
        }
    }

    @Override
    public void transactionFailed(Transaction transaction, PaymentError paymentError) {
        hideProgressDialog();
        showErrorDialog(paymentError);
    }

    private void showErrorDialog(final String message) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                showAlertDialog(message);
            }
        });
    }

    private void showErrorDialog(PaymentError paymentError) {
        showErrorDialog(paymentError.getErrorMessage());
    }

    @Override
    protected void onStart() {
        super.onStart();

        Intent intent = new Intent(this, ConnectService.class);
        startService(intent);
        bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE);
    }

    @Override
    protected void onStop() {
        super.onStop();

        unbindService(serviceConnection);
        stopService(new Intent(this, ConnectService.class));
    }

    @Override
    public void onPaidResult(boolean status, String statusMessage) {
        if (status) {
            Intent intent = new Intent();
            intent.putExtra("status", status);
            intent.putExtra("statusMessage", statusMessage);
            setResult(RESULT_OK, intent);
            finish();
        } else {
            Intent intent = new Intent();
            intent.putExtra("status", status);
            intent.putExtra("statusMessage", statusMessage);
            setResult(RESULT_CANCELED, intent);
            finish();
        }
    }
}