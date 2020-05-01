import 'package:maziwa_otp/base_user/auth/base_user_auth.dart';
import 'package:maziwa_otp/base_user/models/base_user_models.dart' show UserRole;
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mail_server/controllers/mail_server_controllers.dart';

Router mailServerRoutes(Router router){

  router
    .route('/mailserver')
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => Authorizer.bearer(BaseUserBearerPermissionsAouthVerifier([UserRole.admin])))
    .link(()=>MailServerConfigController());

  return router;
}