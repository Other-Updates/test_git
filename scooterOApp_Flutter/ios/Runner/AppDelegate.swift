import UIKit
import Flutter
import GoogleMaps
import SafariServices
import AppTrackingTransparency

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, OPPCheckoutProviderDelegate,PKPaymentAuthorizationViewControllerDelegate,SFSafariViewControllerDelegate  {
    
    
    //MARK:- Properties
    var type:String = "";
    var mode:String = "";
    var checkoutid:String = "";
    var brand:String = "";
    var STCPAY:String = "";
    var number:String = "";
    var holder:String = "";
    var year:String = "";
    var month:String = "";
    var cvv:String = "";
    var pMadaVExp:String = "";
    var prMadaMExp:String = "";
    var brands:String = "";
    var amount:Double = 1;
    
    var safariVC: SFSafariViewController?
    
    //MARK: HYPER PAY PROPERTIES
    var transaction: OPPTransaction?
    var provider = OPPPaymentProvider(mode: OPPProviderMode.test)
    var checkoutProvider: OPPCheckoutProvider?
    
    //MARK: FLUTTER RESULT
    var Presult:FlutterResult?
  
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyDwpXSYswuXaJyfDoBxXTxYeAYRwzZIjGE") //AIzaSyDwpXSYswuXaJyfDoBxXTxYeAYRwzZIj
        initHyperPay() // PAYMENT SDK INITIALIZATION
        requestTrackingPermission() // iOS 14 & above tracking permission
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func requestTrackingPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                print(status)
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

extension AppDelegate {
    //MARK: HYPER PAY PLATFORM CHANNEL OBSERVER
    func initHyperPay() -> () {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "Hyperpay.demo.fultter/channel",
                                                  binaryMessenger: controller.binaryMessenger)
        
        batteryChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            self!.Presult = result
            
            // Note: this method is invoked on the UI thread.
            if call.method == "gethyperpayresponse"{
                
                let args = call.arguments as? Dictionary<String,Any>
                self!.type = (args!["type"] as? String)!
                self!.brand = (args!["brand"] as? String)!
                self!.mode = (args!["mode"] as? String)!
                self!.checkoutid = (args!["checkoutid"] as? String)!
                
                if self!.type == "ReadyUI" {
                    DispatchQueue.main.async {
                        self!.openCheckoutUI(checkoutId: self!.checkoutid, result1: result)
                        
                    }
                } else {
                   
                    if let brand = (args!["brand"] as? String) {
                        self!.brand = brand
                        self!.number = (args!["card_number"] as? String)!
                        self!.holder = (args!["holder_name"] as? String)!
                        self!.year = (args!["year"] as? String)!
                        self!.month = (args!["month"] as? String)!
                        self!.cvv = (args!["cvv"] as? String)!
                        self!.pMadaVExp = (args!["MadaRegexV"] as? String)!
                        self!.prMadaMExp = (args!["MadaRegexM"] as? String)!
                    }
                    if let amount = (args!["Amount"] as? Double) {
                        self!.amount = amount
                    }
                    if let STCPAY = (args!["STCPAY"] as? String) {
                        self!.STCPAY = STCPAY
                    }
                    self!.openCustomUI(checkoutId: self!.checkoutid, result1: result)
                }
                
            }else {
                result(FlutterError(code: "1", message: "Method name is not found", details: ""))
            }
        })
        
    }
}

extension AppDelegate{
    //MARK: CHECKOUT UI
    fileprivate func openCheckoutUI(checkoutId: String,result1: @escaping FlutterResult) {
        
        DispatchQueue.main.async{
            let checkoutSettings = OPPCheckoutSettings()
            checkoutSettings.theme.confirmationButtonColor = HexToColor(hexString: "#00DD00",alpha: 1.0)
            checkoutSettings.theme.navigationBarBackgroundColor = HexToColor(hexString: "#00DD00",alpha: 1.0)
            checkoutSettings.theme.cellHighlightedBackgroundColor = HexToColor(hexString: "#00DD00",alpha: 1.0)
            checkoutSettings.theme.accentColor = HexToColor(hexString: "#00DD00",alpha: 1.0)
            if self.brand == "mada" {
                checkoutSettings.paymentBrands = ["MADA"]
            } else if self.brand == "credit" {
                checkoutSettings.paymentBrands = ["VISA", "MASTER","DIRECTDEBIT_SEPA"]
            } else if self.brand == "APPLEPAY" {
                let paymentRequest = OPPPaymentProvider.paymentRequest(withMerchantIdentifier: "merchant.applepaymosab", countryCode: "SA")
                if #available(iOS 12.1.1, *) {
                    paymentRequest.supportedNetworks = [ PKPaymentNetwork.mada,PKPaymentNetwork.visa,
                                                         PKPaymentNetwork.masterCard ]
                } else {
                    // Fallback on earlier versions
                    paymentRequest.supportedNetworks = [ PKPaymentNetwork.visa,
                                                         PKPaymentNetwork.masterCard ]
                }
                checkoutSettings.applePayPaymentRequest = paymentRequest
                checkoutSettings.paymentBrands = ["APPLEPAY"]
                
            }
    
            if self.mode == "LIVE" {
                
                self.provider = OPPPaymentProvider(mode: OPPProviderMode.live)
                
            }else{
                self.provider = OPPPaymentProvider(mode: OPPProviderMode.test)
            }
            self.checkoutProvider = OPPCheckoutProvider(paymentProvider: self.provider, checkoutID: checkoutId, settings: checkoutSettings)!
            
            print("Check Out ID : \(checkoutId)")
            self.checkoutProvider?.delegate = self
            self.checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
                guard let transaction = transaction else {
                    // Handle invalid transaction, check error
                    print("Error 1",error?.localizedDescription ?? "Error")
                    return
                }
                self.transaction = transaction
                
                if transaction.type == .synchronous {
                    DispatchQueue.main.async {
                        
                        result1("SYNC")
                        
                    }
                } else if transaction.type == .asynchronous {
                    NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveAsynchronousPaymentCallback), name: Notification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"), object: nil)
                } else {
                  
                    print("Error 2",error?.localizedDescription ?? "Error")
                }
            }, cancelHandler: {
                // Executed if the shopper closes the payment page prematurely
                print("Error 3", self.transaction.debugDescription)
            })
        }
    }
}

extension AppDelegate {
    //MARK: CUSTOM UI
    fileprivate func openCustomUI(checkoutId: String,result1: @escaping FlutterResult) {
        
        if self.mode == "LIVE" {
            print("Came here 2")
            self.provider = OPPPaymentProvider(mode: OPPProviderMode.live)
        }
        if self.STCPAY == "enabled" {
            print("Came here 3")
            do {
                let params = try OPPCardPaymentParams(checkoutID: checkoutId,paymentBrand: "STC_PAY")
                params.shopperResultURL = "com.app.scooteroapp://result"
                self.transaction  = OPPTransaction(paymentParams: params)
                self.provider.submitTransaction(self.transaction!) { (transaction, error) in
                    guard let transaction = self.transaction else {
                        // Handle invalid transaction, check error
                        self.createalart(titletext: error?.localizedDescription ?? "Error", msgtext: "")
                        
                        return
                    }
                    
                    if transaction.type == .asynchronous {
                        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveAsynchronousPaymentCallback), name: Notification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"), object: nil)
                        
                        self.safariVC = SFSafariViewController(url: self.transaction!.redirectURL!)
                        self.safariVC?.delegate = self;
                        //  self.present(self.safariVC!, animated: true, completion: nil)
                        
                    } else if transaction.type == .synchronous {
                        // Send request to your server to obtain transaction status
                        result1("success")
                    } else {
                        // Handle the error
                    }
                }
                
                // Set shopper result URL
                //    params.shopperResultURL = "com.companyname.appname.payments://result"
            } catch let error as NSError {
                // See error.code (OPPErrorCode) and error.localizedDescription to identify the reason of failure
                
                self.createalart(titletext: error.localizedDescription, msgtext: "")
                
            }
        } else {
            print(self.brand)
            if self.brand == "APPLEPAY" {
                
                let request = OPPPaymentProvider.paymentRequest(withMerchantIdentifier: "merchant.applepaytest", countryCode: "SA")
                
                request.currencyCode = "SAR"
                self.amount = Double(String(format: "%.2f", self.amount))!
                print(self.amount)
                print(amount)
                
                // Create total item. Label should represent your company.
                // It will be prepended with the word "Pay" (i.e. "Pay Sportswear $100.00")
                request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Hyperpay", amount: NSDecimalNumber(value: self.amount))]
                //  let request1 = PKPaymentRequest() // See above
                if OPPPaymentProvider.canSubmitPaymentRequest(request) {
                    if let vc = PKPaymentAuthorizationViewController(paymentRequest: request) as PKPaymentAuthorizationViewController? {
                        vc.delegate = self
                        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
                    } else {
                        NSLog("Apple Pay not supported.");
                    }
                }
                
            } else if !OPPCardPaymentParams.isNumberValid(self.number, luhnCheck: true) {
                
                self.createalart(titletext: "Card Number is Invalid", msgtext: "")
            }
            else  if !OPPCardPaymentParams.isHolderValid(self.holder) {
                self.createalart(titletext: "Card Holder is Invalid", msgtext: "")
                
            } else   if !OPPCardPaymentParams.isCvvValid(self.cvv) {
                self.createalart(titletext: "CVV is Invalid", msgtext: "")
            } else  if !OPPCardPaymentParams.isExpiryYearValid(self.year) {
                self.createalart(titletext: "Expiry Year is Invalid", msgtext: "")
            } else  if !OPPCardPaymentParams.isExpiryMonthValid(self.month) {
                self.createalart(titletext: "Expiry Month is Invalid", msgtext: "")
            } else {
                print("Came here 4")
            do {
                    
                    if self.brand == "mada" {
                        
                        let bin = self.number.prefix(6)
                        
                        let range = NSRange(location: 0, length: String(bin).utf16.count)
                        
                        let regex = try! NSRegularExpression(pattern: self.pMadaVExp)
                        let regex2 = try! NSRegularExpression(pattern: self.prMadaMExp)
                        
                        
                        if regex.firstMatch(in: String(bin), options: [], range: range) != nil
                            || regex2.firstMatch(in: String(bin), options: [], range: range) != nil {
                            
                            self.brands = "MADA"
                            
                        } else {
                            
                            self.createalart(titletext:  "This card is not Mada card", msgtext: "")
                            
                            
                        }
                 
                    }
                    
                    else if self.number.prefix(1) == "4" {
                        
                        self.brands = "VISA"
                        
                    } else if self.number.prefix(1) == "5" {
                        
                        self.brands = "MASTER";
                        
                        
                    }
                    
//                let params = try OPPCardPaymentParams(checkoutID: self.checkoutid, holder: self.holder, number: self.number, expiryMonth: self.month, expiryYear: self.year, cvv: self.cvv)
                    let params = try OPPCardPaymentParams(checkoutID: checkoutId,paymentBrand: self.brands)
                    params.shopperResultURL = "com.app.scooteroapp://result"
                
                    
                    print(params.cvv)
                    print(params.expiryMonth)
                    print(params.expiryYear)
                    print(params.holder)
                    print(params.number)
                    print(params.paymentBrand)
                    print(params.checkoutID)
                    
                    
                    self.transaction  = OPPTransaction(paymentParams: params)
                    self.provider.submitTransaction(self.transaction!) { (transaction, error) in
                        guard let transaction = self.transaction else {
                            // Handle invalid transaction, check error
                            self.createalart(titletext: error?.localizedDescription ?? "Error", msgtext: "")
                            return
                        }
                        
                        if transaction.type == .asynchronous {
                            
                            self.safariVC = SFSafariViewController(url: self.transaction!.redirectURL!)
                            self.safariVC?.delegate = self;
                            //    self.present(self.safariVC!, animated: true, completion: nil)
                            self.window?.rootViewController?.present(self.safariVC!, animated: true, completion: nil)
                            
                        } else if transaction.type == .synchronous {
                            // Send request to your server to obtain transaction status
                            result1("success")
                        } else {
                            // Handle the error
                            self.createalart(titletext: error?.localizedDescription ?? "Error", msgtext: "")
                        }
                    }
                    
                    // Set shopper result URL
                    //    params.shopperResultURL = "com.companyname.appname.payments://result"
                } catch let error as NSError {
                    // See error.code (OPPErrorCode) and error.localizedDescription to identify the reason of failure
                    
                    self.createalart(titletext: error.localizedDescription, msgtext: "")
                }
           }
        }
    }
}

extension AppDelegate {
    //MARK:- PAYMENT GATEWAY DELEGATE
    
    @objc func didReceiveAsynchronousPaymentCallback(result: @escaping FlutterResult) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"), object: nil)
        
        if self.type == "ReadyUI" {
            self.checkoutProvider?.dismissCheckout(animated: true) {
                DispatchQueue.main.async {
                    result("success")
                }
            }
        } else {
            self.safariVC?.dismiss(animated: true) {
                DispatchQueue.main.async {
                    result("success")
                }
            }
        }
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("urlscheme:" + (url.scheme)!)
        var handler:Bool = false
        if url.scheme?.caseInsensitiveCompare("com.app.scooteroapp") == .orderedSame {
            didReceiveAsynchronousPaymentCallback(result: self.Presult!)
            handler = true
        }
        
        return handler
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        if let params = try? OPPApplePayPaymentParams(checkoutID: self.checkoutid, tokenData: payment.token.paymentData) as OPPApplePayPaymentParams? {
            
            self.transaction  = OPPTransaction(paymentParams: params)
            
            self.provider.submitTransaction(OPPTransaction(paymentParams: params), completionHandler: { (transaction, error) in
                if (error != nil) {
                    // See code attribute (OPPErrorCode) and NSLocalizedDescription to identify the reason of failure.
                    print("Error 4",error?.localizedDescription ?? "Error Occured")
                  
                    self.createalart(titletext: "APPLEPAY Error", msgtext: "")
                } else {
                    // Send request to your server to obtain transaction status.
                    
                    completion(.success)
                    self.Presult!("success")
                    
                    
                }
            })
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension AppDelegate {
    //MARK: ALERT DIALOG
    func createalart(titletext:String,msgtext:String){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: titletext, message:
                                                        msgtext, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default,handler: { (action) in alertController.dismiss(animated: true, completion: nil)}))
            
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            
        }}
}
