import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mpesa/controllers/mpesa_controllers.dart';

Router mpesaRoutes(Router router){
  const String baseUrl = 'paybill';
  
  router
    .route('$baseUrl/confirmation/[:businessId]')
    .link(()=> MpesaConfirmationController());
  
  router
    .route('$baseUrl/validate/[:businessId]')
    .link(()=> MpesaValidationController());
  

  return router;
}