import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/otp/controllers/otp_controllers.dart';
import 'package:maziwa_otp/users/auth/users_auth.dart';

Router otpRoutes(Router router){
  const String baseUrl = 'otp';

  router
    .route('$baseUrl/verify')
    .link(() => Authorizer.basic(UserLoginAouthVerifier()))
    .link(() => OtpVerifyController());
  
  router
    .route('$baseUrl/subscribe')
    .link(() => Authorizer.basic(UserLoginAouthVerifier()))
    .link(() => OtpSubscribeController());
  
  router
    .route('$baseUrl/reports/:businessId')
    .link(() => Authorizer.basic(UserLoginAouthVerifier()))
    .link(() => OtpsReportsController());

  router
    .route('$baseUrl/fetch/:businessId')
    .link(() => Authorizer.basic(UserLoginAouthVerifier()))
    .link(() => FetchOtpsController());

  // totals
  router
    .route('$baseUrl/totals/:businessId')
    .link(() => Authorizer.basic(UserLoginAouthVerifier()))
    .link(() => OtpsAmountController());

  
  
  
  
  

  return router;
}