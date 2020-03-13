import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/otp/controllers/otp_controllers.dart';
import 'package:maziwa_otp/users/auth/users_auth.dart';

Router otpRoutes(Router router){
  const String baseUrl = 'otp';

  router
    .route('$baseUrl/verify')
    .link(() => Authorizer.basic(UserLoginAouthVerifier()))
    .link(() => OtpVerifyController());

  return router;
}