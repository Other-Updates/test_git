package com.app.scooteroapp.networkcall

import com.app.scooteroapp.entities.*
import okhttp3.ResponseBody
import retrofit2.Response

object ApiCall {
    suspend fun register(registerRequest: RegisterRequest) : Response<CommonResponse> =
        RetrofitFactory.apiInterface.register(registerRequest)
    suspend fun login(loginRequest: LoginRequest) : Response<LoginResponse> =
        RetrofitFactory.apiInterface.login(loginRequest)
    suspend fun registerOTPVerify(loginRequest: LoginRequest) : Response<LoginResponse> =
        RetrofitFactory.apiInterface.login(loginRequest)
    suspend fun forgotPassword(forgotRequest: ForgotRequest) : Response<ForgotResponse> =
        RetrofitFactory.apiInterface.forgotPassword(forgotRequest)
    suspend fun scooterDetails(getScootersRequest: GetScootersRequest) : Response<GetScootersResponse> =
        RetrofitFactory.apiInterface.scooterDetails(getScootersRequest)
    suspend fun changePassword(changePasswordRequest: ChangePasswordRequest) : Response<CommonResponse> =
        RetrofitFactory.apiInterface.changePassword(changePasswordRequest)
    suspend fun updateProfile(updateProfileRequest: UpdateProfileRequest) : Response<CommonResponse> =
        RetrofitFactory.apiInterface.updateProfile(updateProfileRequest)
    suspend fun changeMobileNumber(changeMobileNoRequest: ChangeMobileNoRequest) : Response<ResponseBody> =
        RetrofitFactory.apiInterface.changeMobileNumber(changeMobileNoRequest)
    suspend fun changeEmailAddress(changeEmailRequest: ChangeEmailRequest) : Response<ResponseBody> =
        RetrofitFactory.apiInterface.changeEmailAddress(changeEmailRequest)
    suspend fun generateOTP(generateOTPRequest: GenerateOTPRequest) : Response<CommonResponse> =
        RetrofitFactory.apiInterface.generateOTP(generateOTPRequest)
    suspend fun updateOTP(updateOTPRequest: UpdateOTPRequest) : Response<CommonResponse> =
        RetrofitFactory.apiInterface.updatedOTP(updateOTPRequest)
    suspend fun unlockScooter(unlockScooterRequest: UnlockScooterRequest) : Response<UnlockScooterResponse> =
        RetrofitFactory.apiInterface.unlockScooter(unlockScooterRequest)
    suspend fun creditCardPayment(creditCardPaymentRequest: CreditCardPaymentRequest) : Response<CreditCardPaymentResponse> =
        RetrofitFactory.apiInterface.creditCardPayment(creditCardPaymentRequest)
    suspend fun subscriptions(getScootersRequest: GetScootersRequest) : Response<SubscriptionResponse> =
        RetrofitFactory.apiInterface.subscriptions(getScootersRequest)
    suspend fun debitCardPayment(debitPaymentRequest: DebitPaymentRequest) : Response<DebitPaymentResponse> =
        RetrofitFactory.apiInterface.debitCardPayment(debitPaymentRequest)
    suspend fun endRide(endRideRequest: EndRideRequest) : Response<EndRideResponse> =
        RetrofitFactory.apiInterface.endRide(endRideRequest)
    suspend fun rideFeedBack(feedbackRequest: FeedbackRequest) : Response<CommonResponse> =
        RetrofitFactory.apiInterface.rideFeedBack(feedbackRequest)
    suspend fun invoiceList(getScootersRequest: GetScootersRequest) : Response<InvoiceListResponse> =
        RetrofitFactory.apiInterface.invoiceList(getScootersRequest)
    suspend fun invoiceDetails(invoiceDetailRequest: InvoiceDetailRequest) : Response<InvoiceDetailResponse> =
        RetrofitFactory.apiInterface.invoiceDetails(invoiceDetailRequest)
    suspend fun languageContents(languageRequest: LanguageRequest) : Response<LanguageResponse> =
        RetrofitFactory.apiInterface.languageContents(languageRequest)
    suspend fun dashboardDet(dashboardRequest: DashboardRequest) : Response<DashboardResponse> =
        RetrofitFactory.apiInterface.dashboardDetails(dashboardRequest)
    suspend fun sendOTP(dashboardRequest: DashboardRequest) : Response<CommonResponse> =
        RetrofitFactory.apiInterface.sendOTP(dashboardRequest)
    suspend fun checkOTP(updateOTPRequest: UpdateOTPRequest) : Response<LoginResponse> =
        RetrofitFactory.apiInterface.checkCustomerOTP(updateOTPRequest)
    suspend fun registerCheckOTP(checkOTPRequest: CheckRegisterOTPRequest) : Response<LoginResponse> =
        RetrofitFactory.apiInterface.checkRegisterOTP(checkOTPRequest)
    suspend fun customerWallet(dashboardRequest: DashboardRequest) : Response<WalletResponse> =
        RetrofitFactory.apiInterface.customerWallet(dashboardRequest)
    suspend fun addToWallet(addWalletRequest: AddWalletRequest) : Response<CommonResponse> =
        RetrofitFactory.apiInterface.addToWallet(addWalletRequest)
    suspend fun creditedDetails(creditedDetailsRequest: CreditedDetailsRequest) : Response<CreditedDetailsResponse> =
        RetrofitFactory.apiInterface.creditedDetails(creditedDetailsRequest)
    suspend fun debitedDetails(debitedDetailsRequest: DebitedDetailsRequest) : Response<DebitedDetailsResponse> =
        RetrofitFactory.apiInterface.debitedDetails(debitedDetailsRequest)
}