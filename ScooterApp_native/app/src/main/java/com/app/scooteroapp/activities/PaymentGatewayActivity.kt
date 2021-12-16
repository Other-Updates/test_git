package com.app.scooteroapp.activities

import android.os.Bundle
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import com.app.scooteroapp.R

class PaymentGatewayActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_payment_gateway)
      //  title = "KotlinApp"
        val webView = findViewById<WebView>(R.id.webview)
        webView.webViewClient =WebViewClient()

    /*    var url: URL
        var urlString: String
        var resourcePath: String
        resourcePath = null.toString()

        urlString = PaymentConstants.BASE_URL + "/status?resourcePath=" +
                URLEncoder.encode(resourcePath, "UTF-8")*/
    webView.loadUrl("https://www.hyperpay.com/")

        /*"https://mtf.gateway.mastercard.com/acs/VisaACS/496c2553-fa03-4de2-aa9b-a4e638ff2131"*/
        val webSettings = webView.settings
        webSettings.javaScriptEnabled = true
    }



   /* webView.setWebViewClient(new WebViewClient() {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            if (url != null && url.contains("://") && url.toLowerCase().startsWith("market:")) {
                try {
                    view.getContext().startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
                    return true;
                } catch (Exception ex) {
                }
            }
            view.loadUrl(url);
            return true;
        }
    });*/



    /* override fun onBackPressed() {
         if (webView!!.canGoBack()) {
             webView.goBack()
         } else {
             super.onBackPressed()
         }
     }*/

}


