import 'package:maziwa_otp/base_user/auth/base_user_auth.dart';
import 'package:maziwa_otp/base_user/controllers/accounts/accounts_controllers.dart';
import 'package:maziwa_otp/base_user/controllers/base_user_controlers.dart';
import 'package:maziwa_otp/base_user/controllers/businesses/businesses_controllers.dart';
import 'package:maziwa_otp/base_user/models/base_user_models.dart' show UserRole;
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/registration_token/controllers/registration_token_controllers.dart';
import 'package:maziwa_otp/token/controllers/base_user_token_controller.dart';
import 'package:maziwa_otp/users/controllers/users_controllers.dart' show UserStateController;

Router baseUserRoute(Router router){
  const String _rootPath = 'arronax/user';

  // create
  router
    .route('/$_rootPath/create')
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => Authorizer.bearer(BaseUserBearerPermissionsAouthVerifier([UserRole.admin])))
    .link(()=> BaseUserCreateController());

  // delete
  router
    .route('/$_rootPath/delete/:userId')
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => Authorizer.bearer(BaseUserBearerPermissionsAouthVerifier([UserRole.admin])))
    .link(()=> BaseUserCreateController());
  
  
  // edit
  router
    .route('/$_rootPath/edit/:userId')
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => Authorizer.bearer(BaseUserBearerPermissionsAouthVerifier([UserRole.admin, UserRole.moderator])))
    .link(()=> BaseUserEditRoleController());
  
  // get
  router
    .route('/$_rootPath/[:userId]')
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => Authorizer.bearer(BaseUserBearerPermissionsAouthVerifier([UserRole.admin, UserRole.moderator, UserRole.normal])))
    .link(()=> BaseUserController());
  
  // login
  router
    .route('/$_rootPath/login')
    .link(() => Authorizer.basic(BaseUserBasicAouthVerifier()))
    .link(()=> BaseUserTokenController());

  // logout
  router
    .route('/$_rootPath/logout')
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(()=> BaseUserLogOutController());

  // reset passwod
  router
    .route('/$_rootPath/resetPassword')
    .link(()=> BaseUserResetPasswordController());

  
  router
    .route('/$_rootPath/changePassword')
    .link(() => Authorizer.basic(BaseUserBasicTempPassordAouthVerifier()))
    .link(()=> BaseUserChangePasswordController());

  
  // create registration token
  router
    .route('/$_rootPath/registartionToken/[:token]')
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(()=> RegistrationTokenController());

  
  // ACCOUNTS
  
  // accout
  router
    .route('/arronax/accounts/[:email]')
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => Authorizer.bearer(BaseUserBearerPermissionsAouthVerifier([UserRole.admin, UserRole.moderator, UserRole.normal])))
    .link(()=> UserFetchController());
  
  // state
  router
    .route('/arronax/accounts/state/[:email]')
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => Authorizer.bearer(BaseUserBearerPermissionsAouthVerifier([UserRole.admin, UserRole.moderator])))
    .link(()=> UserStateController());
  
  // delete
  router
    .route('/arronax/accounts/delete/:email')
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => Authorizer.bearer(BaseUserBearerPermissionsAouthVerifier([UserRole.admin, UserRole.moderator])))
    .link(()=> UserDeleteController());


  // BUSINESSES
  // businesses
  router
    .route('/arronax/businesses/[:businessId]')
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => Authorizer.bearer(BaseUserBearerPermissionsAouthVerifier([UserRole.admin, UserRole.moderator, UserRole.normal])))
    .link(()=> BusinessesFetchController());
  
  // delete
  router
    .route('/arronax/businesses/delete/:businessId')
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => Authorizer.bearer(BaseUserBearerPermissionsAouthVerifier([UserRole.admin, UserRole.moderator])))
    .link(()=> BusinessesDeleteController());


  // REQUEST  
  router
    .route('/arronax/requests')
    .link(() => Authorizer.bearer(BaseUserBearerAouthVerifier()))
    .link(() => Authorizer.bearer(BaseUserBearerPermissionsAouthVerifier([UserRole.admin, UserRole.moderator, UserRole.normal])))
    .link(()=> BusinessesFetchController());
  
  
  

  return router;
}