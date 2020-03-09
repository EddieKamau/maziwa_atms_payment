import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/otp/controllers/otp_controllers.dart';

Router otpRoutes(Router router){
  const String baseUrl = 'otp';

  router
    .route('$baseUrl/verify')
    .link(() => OtpVerifyController());

  return router;
}