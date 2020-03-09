import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/users/models/user_model.dart';

class UserLoginAouthVerifier extends AuthValidator {

  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
    Authorization _authorization;
    final List<String> _aouthDetails = authorizationData.toString().split(":");

    final UserModel userModel = UserModel(email: _aouthDetails[0], password: _aouthDetails[1]);

    if(await userModel.verifyPassword()){

      final Map<String, dynamic> _dbRes = await userModel.findOneBy(where.eq('email', _aouthDetails[0]), fields: ['_id']);

      if(_dbRes['status'] != 0){
        _authorization = null;
      }else{
        final item = _dbRes['body'];
        if(item == null){
          _authorization = null;
        }else{
          _authorization = Authorization(item['_id'].toString().split('\"')[1], 0, null);
        }
      }
      
    }

    
    return _authorization;
  }
}