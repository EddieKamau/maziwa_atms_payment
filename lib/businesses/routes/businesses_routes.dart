import 'package:maziwa_otp/businesses/controllers/businesses_controllers.dart';
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/users/auth/users_auth.dart' show UserLoginAouthVerifier;

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

  

  return router;
}