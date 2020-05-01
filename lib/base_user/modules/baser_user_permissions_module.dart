import 'package:maziwa_otp/base_user/models/base_user_models.dart' show BaseUserModel;

class BaseUserPermissionsModule{
  BaseUserPermissionsModule(this.userId);

  final String userId;
  final BaseUserModel _userModel = BaseUserModel();

  String _role;

  bool get isAdmin => _role == 'admin';
  bool get isModerator => _role == 'moderator';
  bool get isNormal => _role == 'normal';
  bool get isGuest => _role == 'guest';
  bool get isAnonymous => _role == 'anonymous';

  Future<Null> getPermissions()async{

    final Map<String, dynamic> _dbRes = await _userModel.findById(userId, fields: ['role']);
    if(_dbRes['status'] == 0){
      if(_dbRes['body'] != null){

        _role = _dbRes['body']['role'].toString();

      }else{
        return null;
      }

    } else{
      return null;
    }


  }

}