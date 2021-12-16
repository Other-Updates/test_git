package com.app.scooteroapp.networkcall

import com.app.scooteroapp.constants.Constants
import com.google.gson.GsonBuilder
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

object RetrofitFactory {
    private val logInterceptor : HttpLoggingInterceptor = HttpLoggingInterceptor().apply { level = HttpLoggingInterceptor.Level.BODY }
    private val gson = GsonBuilder().setLenient().create()
    private val apiInterceptor = Interceptor{chain->
        val request = chain.request()
        val response = chain.proceed(request)
        response
    }

    private val httpClient : OkHttpClient = OkHttpClient.Builder().apply {
        connectTimeout(2, TimeUnit.MINUTES)
        writeTimeout(1, TimeUnit.MINUTES)
        readTimeout(2, TimeUnit.MINUTES)
        addInterceptor(logInterceptor)
        addInterceptor(apiInterceptor)
    }.build()

    fun retrofit () : Retrofit = Retrofit.Builder() .apply {
        baseUrl(Constants.BASE_URL)
        client(httpClient)
        addConverterFactory(GsonConverterFactory.create(gson))
    }.build()

    val apiInterface : ApiInterface = retrofit().create(ApiInterface::class.java)

}