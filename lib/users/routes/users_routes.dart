import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/token/controllers/tokens_controller.dart';
import 'package:maziwa_otp/users/auth/bearer_auth.dart';
import 'package:maziwa_otp/users/auth/users_auth.dart';
import 'package:maziwa_otp/users/controllers/user_logout_controller.dart';
import 'package:maziwa_otp/users/controllers/users_controllers.dart';

Router usersRoutes(Router router){
  const String baseUrl = '/users';
  
  // register
  router
    .route('$baseUrl')
    .link(() => UserController());

  // login
  router
    .route('/$baseUrl/login')
    .link(() => Authorizer.basic(UserLoginAouthVerifier()))
    .link(()=> UserTokenController());

  // logout
  router
    .route('/$baseUrl/logout')
    .link(() => Authorizer.bearer(UserBearerAouthVerifier()))
    .link(()=> UserLogOutController());

  return router;
}