import 'package:maziwa_otp/businesses/controllers/businesses_controllers.dart';
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mpesa/controllers/mpesa_controllers.dart' show PaymentsReportsController, PaymentsTotals;
import 'package:maziwa_otp/sms/controllers/sms_controllers.dart' show SmsReportsController;
import 'package:maziwa_otp/users/auth/users_auth.dart';

Router businessRoutes(Router router){
  const String baseUrl = '/business';

  router
    .route('$baseUrl/[:businessId]')
    .link(() => Authorizer.basic(UserLoginAouthVerifier()))
    .link(() => BusinessCreateController());

  router
    .route('$baseUrl/simulate/[:businessId]')
    .link(() => Authorizer.basic(UserLoginAouthVerifier()))
    .link(() => BusinessSimulatePaymentController());

  router
    .route('$baseUrl/smsReports/:businessId')
    .link(() => Authorizer.basic(UserLoginAouthVerifier()))
    .link(() => SmsReportsController());

  router
    .route('$baseUrl/paymentReports/:businessId')
    .link(() => Authorizer.basic(UserLoginAouthVerifier()))
    .link(() => PaymentsReportsController());

  router
    .route('$baseUrl/totals/:businessId')
    .link(() => Authorizer.basic(UserLoginAouthVerifier()))
    .link(() => PaymentsTotals());

  
  

  

  return router;
}