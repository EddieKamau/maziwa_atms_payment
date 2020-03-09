import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/users/controllers/users_controllers.dart';

Router usersRoutes(Router router){
  const String baseUrl = '/users';

  router
    .route('$baseUrl')
    .link(() => UserController());

  return router;
}