package com.app.scooteroapp.payment;

import android.os.AsyncTask;
import android.util.JsonReader;
import android.util.Log;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import javax.net.ssl.HttpsURLConnection;

import kotlin.text.Charsets;


/**
 * Represents an async task to request a payment status from the server.
 */
public class PaymentStatusRequestAsyncTask extends AsyncTask<String, Void, String> {

    private PaymentStatusRequestListener listener;

    public PaymentStatusRequestAsyncTask(PaymentStatusRequestListener listener) {
        this.listener = listener;
    }

    @Override
    protected String doInBackground(String... params) {
        if (params.length != 1) {
            return null;
        }

        String resourcePath = params[0];

        if (resourcePath != null) {
            //return requestPaymentStatus(resourcePath);
            return requestScooterO(resourcePath);
        }

        return null;
    }

    @Override
    protected void onPostExecute(String paymentStatus) {
        if (listener != null) {
            if (paymentStatus == null) {
                listener.onErrorOccurred();

                return;
            }

            listener.onPaymentStatusReceived(paymentStatus);
        }
    }

    private String requestPaymentStatus(String resourcePath) {
        if (resourcePath == null) {
            return null;
        }

        URL url;
        String urlString;
        HttpURLConnection connection = null;
        String paymentStatus = null;

        try {
            urlString = PaymentConstants.BASE_URL + "/status?resourcePath=" +
                    URLEncoder.encode(resourcePath, "UTF-8");

            Log.d(PaymentConstants.LOG_TAG, "Status request url: " + urlString);

            url = new URL(urlString);
            connection = (HttpURLConnection) url.openConnection();
            connection.setConnectTimeout(PaymentConstants.CONNECTION_TIMEOUT);

            JsonReader jsonReader = new JsonReader(
                    new InputStreamReader(connection.getInputStream(), "UTF-8"));

            jsonReader.beginObject();

            while (jsonReader.hasNext()) {
                if (jsonReader.nextName().equals("paymentResult")) {
                    paymentStatus = jsonReader.nextString();
                } else {
                    jsonReader.skipValue();
                }
            }

            jsonReader.endObject();
            jsonReader.close();

            Log.d(PaymentConstants.LOG_TAG, "Status: " + paymentStatus);
        } catch (Exception e) {
            Log.e(PaymentConstants.LOG_TAG, "Error: ", e);
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }

        return paymentStatus;
    }

    private String request(String id)  {
        if(id.contains("/")){
            id = id.split("/")[2];
        }
        try{
            URL url = new URL("https://test.oppwa.com/v1/checkouts/" + id + "/payment&entityId=8ac7a4c7762d42e301763890b1b81981");

            HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer OGFjN2E0Yzc3NjJkNDJlMzAxNzYzODkwNDk1ZDE5N2R8SEVwNVJkZFlkdw==");
            int responseCode = conn.getResponseCode();
            InputStream is;

            if (responseCode >= 400) is = conn.getErrorStream();
            else is = conn.getInputStream();

            String paymentStatus = "";
            StringBuilder stringBuilder = new StringBuilder();
            String line = null;

            try (BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(is, Charsets.UTF_8))) {
                while ((line = bufferedReader.readLine()) != null) {
                    stringBuilder.append(line);
                }
            }

            JSONObject jsonObject = new JSONObject(stringBuilder.toString());
            paymentStatus = jsonObject.getString("paymentStatus");
            return paymentStatus;
        }catch (Exception ex){
            ex.printStackTrace();
            return "";
        }
    }

    private String requestScooterO(String id)  {
        if(id.contains("/")){
            id = id.split("/")[2];
        }
        try{
            URL url = new URL("https://demo.f2fsolutions.co.in/ScooterO/api/api_payment_status");

            JSONObject req = new JSONObject();
            req.put("checkout_id",id);

            HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setRequestProperty("Accept", "application/json");
//            conn.setRequestProperty("Authorization", "Bearer OGFjN2E0Yzc3NjJkNDJlMzAxNzYzODkwNDk1ZDE5N2R8SEVwNVJkZFlkdw==");
            conn.setFixedLengthStreamingMode(req.toString().getBytes().length);
            conn.setDoInput(true);
            conn.setDoOutput(true);

            DataOutputStream wr = new DataOutputStream(conn.getOutputStream());
            wr.writeBytes(req.toString());
            wr.flush();
            wr.close();

            int responseCode = conn.getResponseCode();
            InputStream is;

            if (responseCode >= 400) is = conn.getErrorStream();
            else is = conn.getInputStream();

            String paymentStatus = "";
            StringBuilder stringBuilder = new StringBuilder();
            String line = null;

            try (BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(is, Charsets.UTF_8))) {
                while ((line = bufferedReader.readLine()) != null) {
                    stringBuilder.append(line);
                }
            }

            JSONObject jsonObject = new JSONObject(stringBuilder.toString());
            JSONObject dataObject = jsonObject.getJSONObject("data");
            JSONObject resultObject = dataObject.getJSONObject("result");
            paymentStatus = resultObject.getString("description");
            return paymentStatus;
        }catch (Exception ex){
            ex.printStackTrace();
            return "";
        }
    }
}
