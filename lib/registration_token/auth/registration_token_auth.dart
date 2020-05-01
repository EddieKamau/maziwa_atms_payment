import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/registration_token/models/registration_token_models.dart';

class RegistrationTokenAouthVerifier extends AuthValidator{
  final RegitrationTokenModel regitrationTokenModel = RegitrationTokenModel();
  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async{
    final String _token = authorizationData.toString();
    print(_token);
    print('he$_token.k');
    final Map<String, dynamic> _regitrationMap = await regitrationTokenModel.findOneBy(where.eq("token", _token));

    if(_regitrationMap['status'] == 0){
      if(_regitrationMap['body'] != null){
        if(_regitrationMap['body']['active'] == true && _regitrationMap['body']['used'] == false){
          return Authorization(_token, 0, this);
        } else{
          return null;
        }

      } else{
        return null;
      }

    }else{
      return null;
    }

  }
}