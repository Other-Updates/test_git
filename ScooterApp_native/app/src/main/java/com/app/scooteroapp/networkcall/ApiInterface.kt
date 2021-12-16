package com.app.scooteroapp.networkcall

import com.app.scooteroapp.entities.*
import okhttp3.ResponseBody
import retrofit2.Response
import retrofit2.http.*

interface ApiInterface {
    @POST("api_customer_registeration")
    suspend fun register(@Body registerRequest: RegisterRequest): Response<CommonResponse>

    @POST("api_customer_login")
    suspend fun login(@Body loginRequest: LoginRequest): Response<LoginResponse>

    @POST("api_forget_password")
    suspend fun forgotPassword(@Body forgotRequest: ForgotRequest):Response<ForgotResponse>

    @POST("api_get_scooter_details")
    suspend fun scooterDetails(@Body getScootersRequest: GetScootersRequest) : Response<GetScootersResponse>

    @POST("api_change_new_password")
    suspend fun changePassword(@Body changePasswordRequest: ChangePasswordRequest): Response<CommonResponse>

    @POST("api_update_profile_details")
    suspend fun updateProfile(@Body updateProfileRequest: UpdateProfileRequest) : Response<CommonResponse>

    @POST("api_change_mobile_number")
    suspend fun changeMobileNumber(@Body changeMobileNoRequest: ChangeMobileNoRequest) : Response<ResponseBody>

    @POST("api_change_email_address")
    suspend fun changeEmailAddress(@Body changeEmailRequest: ChangeEmailRequest) : Response<ResponseBody>

    @POST("api_generate_otp")
    suspend fun generateOTP(@Body generateOTPRequest: GenerateOTPRequest) : Response<CommonResponse>

    @POST("api_generate_otp")
    suspend fun updatedOTP(@Body updateOTPRequest: UpdateOTPRequest) : Response<CommonResponse>

    @POST("scan_qr_code")
    suspend fun unlockScooter(@Body unlockScooterRequest: UnlockScooterRequest) : Response<UnlockScooterResponse>

    @POST("api_payments")
    suspend fun creditCardPayment(@Body creditCardPaymentRequest: CreditCardPaymentRequest) : Response<CreditCardPaymentResponse>

    @POST("api_subscription_plan")
    suspend fun subscriptions(@Body getScootersRequest: GetScootersRequest) : Response<SubscriptionResponse>

    @POST("api_payments")
    suspend fun debitCardPayment(@Body debitPaymentRequest: DebitPaymentRequest) : Response<DebitPaymentResponse>

    @POST("api_ride_end")
    suspend fun endRide(@Body endRideRequest: EndRideRequest) : Response<EndRideResponse>

    @POST("api_ride_feedback")
    suspend fun rideFeedBack(@Body feedbackRequest: FeedbackRequest) : Response<CommonResponse>

    @POST("api_invoice_list")
    suspend fun invoiceList(@Body getScootersRequest: GetScootersRequest) : Response<InvoiceListResponse>

    @POST("api_invoice_details")
    suspend fun invoiceDetails(@Body invoiceDetailRequest: InvoiceDetailRequest) : Response<InvoiceDetailResponse>

    @POST("api_get_all_contents")
    suspend fun languageContents(@Body langRequest:LanguageRequest) : Response<LanguageResponse>

    @POST("api_customer_dashboard")
    suspend fun dashboardDetails(@Body dashboardRequest: DashboardRequest) : Response<DashboardResponse>

    @POST("api_send_otp")
    suspend fun sendOTP(@Body dashboardRequest: DashboardRequest) : Response<CommonResponse>

    /*@POST("api_check_customer_otp")
    suspend fun checkCustomerOTP(@Body otpCheckOTPRequest: CheckOTPRequest) : Response<LoginResponse>*/

    @POST("api_generate_otp")
    suspend fun checkCustomerOTP(@Body updateOTPRequest: UpdateOTPRequest) : Response<LoginResponse>

    @POST("api_check_customer_otp")
    suspend fun checkRegisterOTP(@Body registerCheckOTPRequest: CheckRegisterOTPRequest) : Response<LoginResponse>

    @POST("api_customer_wallet_details")
    suspend fun customerWallet(@Body dashboardRequest: DashboardRequest) : Response<WalletResponse>

    @POST("api_update_customer_wallet")
    suspend fun addToWallet(@Body addWalletRequest: AddWalletRequest) : Response<CommonResponse>

    @POST("api_customer_pay_details")
    suspend fun creditedDetails(@Body creditedDetailsRequest: CreditedDetailsRequest) : Response<CreditedDetailsResponse>

    @POST("api_customer_pay_details")
    suspend fun debitedDetails(@Body debitedDetailsRequest: DebitedDetailsRequest) : Response<DebitedDetailsResponse>


}