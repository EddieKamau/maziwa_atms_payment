import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/otp/controllers/otp_controllers.dart';
import 'package:maziwa_otp/users/auth/bearer_auth.dart';

Router otpRoutes(Router router){
  const String baseUrl = 'otp';

  router
    .route('$baseUrl/verify')
    .link(() => Authorizer.bearer(UserBearerAouthVerifier()))
    .link(() => OtpVerifyController());
  
  router
    .route('$baseUrl/subscribe')
    .link(() => Authorizer.bearer(UserBearerAouthVerifier()))
    .link(() => OtpSubscribeController());
  
  router
    .route('$baseUrl/reports/:businessId')
    .link(() => Authorizer.bearer(UserBearerAouthVerifier()))
    .link(() => OtpsReportsController());

  router
    .route('$baseUrl/fetch/:businessId')
    .link(() => Authorizer.bearer(UserBearerAouthVerifier()))
    .link(() => FetchOtpsController());

  
  
  
  
  

  return router;
}