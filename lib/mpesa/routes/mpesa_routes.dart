import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mpesa/controllers/mpesa_controllers.dart';

Router mpesaRoutes(Router router){
  const String baseUrl = 'paybill';
  
  router
    .route('$baseUrl/confirmation')
    .link(()=> MpesaConfirmationController());
  
  router
    .route('$baseUrl/validate')
    .link(()=> MpesaValidationController());
  

  return router;
}