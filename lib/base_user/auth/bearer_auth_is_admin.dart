import 'package:maziwa_otp/base_user/models/base_user_models.dart' show UserRole, UserRoleValue;
import 'package:maziwa_otp/base_user/modules/base_user_modules.dart' show BaseUserPermissionsModule;
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/token/models/token_model.dart';
import 'package:maziwa_otp/models/utils/database_collection_names.dart' show baseUserCollection;

class BaseUserBearerPermissionsAouthVerifier extends AuthValidator{
  BaseUserBearerPermissionsAouthVerifier(this.roles);
  final List<UserRole> roles;


  TokenModel tokenModel = TokenModel();
  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
    final String _token = authorizationData.toString();
    final Map<String, dynamic> _tokenMap = await tokenModel.findBySelector(where.eq("token", _token));
    final int seconds = (DateTime.now().millisecondsSinceEpoch/1000).floor();
    if(_tokenMap['status'] != 0){
      return null;
    } else{
      final _tokenInfo = _tokenMap['body'].length !=0 ? _tokenMap['body'].first : null;
      if (_tokenInfo == null) {
        return null;
      }

      if (seconds >= int.parse(_tokenInfo['validTill'].toString())) {
        return null;
      } else {
        if(_tokenInfo['collection'].toString() == baseUserCollection){
          final String _userId = _tokenInfo['ownerId'].toString();

          final BaseUserPermissionsModule baseUserPermissionsModule = BaseUserPermissionsModule(_userId);
          await baseUserPermissionsModule.getPermissions();
          final bool _check = checkPermission(roles, baseUserPermissionsModule);

          if(_check){

            return Authorization(_userId, 0, this, scopes: getScopes(roles));

          } else{
            return null;
          }
        } else {
          return null;
        }
      }
    }
  }
}

bool checkPermission(List<UserRole> _roles, BaseUserPermissionsModule _baseUserPermissionsModule){
  bool _check = false;
  _roles.forEach((UserRole _role){

    switch (_role) {
      case UserRole.admin:
        _check = _check || _baseUserPermissionsModule.isAdmin;
        break;
      case UserRole.anonymous:
        _check = _check || _baseUserPermissionsModule.isAnonymous;
        break;
      case UserRole.guest:
        _check = _check || _baseUserPermissionsModule.isGuest;
        break;
      case UserRole.moderator:
        _check = _check || _baseUserPermissionsModule.isModerator;
        break;
      case UserRole.normal:
        _check = _check || _baseUserPermissionsModule.isNormal;
        break;
      default:
        _check = _check || false;
    }

  });
  return _check;
}

List<AuthScope> getScopes(List<UserRole> _roles){
  final List<AuthScope> _scopes = [];
  final AuthScope _getScope = AuthScope('get');
  final AuthScope _deleteScope = AuthScope('delete');
  final AuthScope _postScope = AuthScope('post');
  final AuthScope _putScope = AuthScope('put');

  _roles.forEach((UserRole _role){
    final AuthScope _roleScope = AuthScope(_role.value);
    switch (_role) {
      case UserRole.admin:
        _scopes.addAll([_getScope, _deleteScope, _postScope, _putScope, _roleScope]);
        break;
      case UserRole.anonymous:
        _scopes.addAll([_roleScope]);
        break;
      case UserRole.guest:
        _scopes.addAll([_roleScope]);
        break;
      case UserRole.moderator:
        _scopes.addAll([_getScope, _putScope, _roleScope]);
        break;
      case UserRole.normal:
        _scopes.addAll([_getScope, _roleScope]);
        break;
      default:
        _scopes.addAll([]);
    }
  });

  return _scopes.toSet().toList();
}

