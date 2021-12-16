package com.app.scooteroapp.payment;

import android.os.AsyncTask;
import android.util.JsonReader;
import android.util.Log;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;

import kotlin.text.Charsets;


/**
 * Represents an async task to request a checkout id from the server.
 */
public class CheckoutIdRequestAsyncTask extends AsyncTask<String, Void, String> {

    private CheckoutIdRequestListener listener;

    public CheckoutIdRequestAsyncTask(CheckoutIdRequestListener listener) {
        this.listener = listener;
    }

    @Override
    protected String doInBackground(String... params) {
        try{
            if (params.length != 2) {
                return null;
            }

            String amount = params[0];
            String currency = params[1];

            return requestScooterO(); //requestCheckoutId(amount, currency);
        }catch (Exception ex){
            ex.printStackTrace();
            return "";
        }
    }

    @Override
    protected void onPostExecute(String checkoutId) {
        PaymentConstants.COID = checkoutId;
        if (listener != null) {
            listener.onCheckoutIdReceived(checkoutId);
        }
    }

    private String request() throws IOException {
        try{
            URL url = new URL("https://test.oppwa.com/v1/checkouts");

            HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer OGFjN2E0Yzc3NjJkNDJlMzAxNzYzODkwNDk1ZDE5N2R8SEVwNVJkZFlkdw==");
            conn.setDoInput(true);
            conn.setDoOutput(true);

            String data = ""
                    + "entityId=8ac7a4c7762d42e301763890b1b81981"
                    + "&amount=" + PaymentConstants.Config.AMOUNT
                    + "&currency=SAR"
                    + "&paymentType=DB"
                    + "&notificationUrl=http://www.example.com/notify";

            DataOutputStream wr = new DataOutputStream(conn.getOutputStream());
            wr.writeBytes(data);
            wr.flush();
            wr.close();
            int responseCode = conn.getResponseCode();
            InputStream is;

            if (responseCode >= 400) is = conn.getErrorStream();
            else is = conn.getInputStream();

            StringBuilder stringBuilder = new StringBuilder();
            String line = null;

            try (BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(is, Charsets.UTF_8))) {
                while ((line = bufferedReader.readLine()) != null) {
                    stringBuilder.append(line);
                }
            }

            JSONObject jsonObject = new JSONObject(stringBuilder.toString());
            String checkoutId = jsonObject.getString("id");
            return checkoutId;
        }catch (Exception ex) {
            ex.printStackTrace();
            return "";
        }
    }

    private String requestScooterO() throws IOException {
        try{
            URL url = new URL("https://demo.f2fsolutions.co.in/ScooterO/api/api_prepare_checkout");

            JSONObject req = new JSONObject();
            req.put("amount",PaymentConstants.Config.AMOUNT);

            HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setRequestProperty("Accept", "application/json");
//            conn.setRequestProperty("Authorization", "Bearer OGFjN2E0Yzc3NjJkNDJlMzAxNzYzODkwNDk1ZDE5N2R8SEVwNVJkZFlkdw==");
            conn.setFixedLengthStreamingMode(req.toString().getBytes().length);
            conn.setDoInput(true);
            conn.setDoOutput(true);

            /*OutputStream os = new BufferedOutputStream(conn.getOutputStream());
            os.write(req.toString().getBytes());
            os.flush();

            String data = ""
                    + "entityId=8ac7a4c7762d42e301763890b1b81981"
                    + "&amount=" + PaymentConstants.Config.AMOUNT
                    + "&currency=SAR"
                    + "&paymentType=DB"
                    + "&notificationUrl=http://www.example.com/notify";
*/
            DataOutputStream wr = new DataOutputStream(conn.getOutputStream());
            wr.writeBytes(req.toString());
            wr.flush();
            wr.close();
            int responseCode = conn.getResponseCode();
            InputStream is;

            if (responseCode >= 400) is = conn.getErrorStream();
            else is = conn.getInputStream();

            StringBuilder stringBuilder = new StringBuilder();
            String line = null;

            try (BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(is, Charsets.UTF_8))) {
                while ((line = bufferedReader.readLine()) != null) {
                    stringBuilder.append(line);
                }
            }

            JSONObject jsonObject = new JSONObject(stringBuilder.toString());
            JSONObject dataObject = jsonObject.getJSONObject("data");
            String checkoutId = dataObject.getString("id");
            return checkoutId;
        }catch (Exception ex) {
            ex.printStackTrace();
            return "";
        }
    }

    private String requestPay() throws IOException {
        URL url = new URL("https://test.oppwa.com/v1/checkouts/3035EFA52EE5B9B177C6CFC87F7D39D9.uat01-vm-tx04/payment&entityId=8ac7a4c7762d42e301763890b1b81981");

                HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer OGFjN2E0Yzc3NjJkNDJlMzAxNzYzODkwNDk1ZDE5N2R8SEVwNVJkZFlkdw==");
        int responseCode = conn.getResponseCode();
        InputStream is;

        if (responseCode >= 400) is = conn.getErrorStream();
        else is = conn.getInputStream();

        StringBuilder stringBuilder = new StringBuilder();
        String line = null;

        try (BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(is, Charsets.UTF_8))) {
            while ((line = bufferedReader.readLine()) != null) {
                stringBuilder.append(line);
            }
        }
        return stringBuilder.toString();
    }

    private String requestCheckoutId(String amount,
                                     String currency) {
        String urlString = PaymentConstants.BASE_URL + "/token?" +
                "amount=" + amount +
                "&currency=" + currency +
                "&paymentType=DB";
                /* store notificationUrl on your server to change it any time without updating the app */
                //"&notificationUrl=http://52.59.56.185:80/notification";
        URL url;
        HttpURLConnection connection = null;
        String checkoutId = null;

        try {
            url = new URL(urlString);
            connection = (HttpURLConnection) url.openConnection();
            connection.setConnectTimeout(PaymentConstants.CONNECTION_TIMEOUT);

            JsonReader reader = new JsonReader(
                    new InputStreamReader(connection.getInputStream(), "UTF-8"));

            reader.beginObject();

            while (reader.hasNext()) {
                if (reader.nextName().equals("checkoutId")) {
                    checkoutId = reader.nextString();

                    break;
                }
            }

            reader.endObject();
            reader.close();

            Log.d(PaymentConstants.LOG_TAG, "Checkout ID: " + checkoutId);
        } catch (Exception e) {
            Log.e(PaymentConstants.LOG_TAG, "Error: ", e);
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }

        return checkoutId;
    }
}