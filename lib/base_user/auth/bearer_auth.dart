import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/models/utils/database_collection_names.dart' show baseUserCollection;
import 'package:maziwa_otp/token/models/token_model.dart';

class BaseUserBearerAouthVerifier extends AuthValidator{
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
          return Authorization(_tokenInfo['ownerId'].toString(), 0, this, credentials: AuthBasicCredentials()..username = _token);
        } else {
          return null;
        }
      }
    }
  }
}

