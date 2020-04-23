
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/token/models/token_model.dart';

class UserTokenController extends ResourceController{
  TokenModel tokenModel = TokenModel();
  static int _duration = 300; // 300 seconds for 5 mins


  @Operation.get()
  Future<Response> getBaseUserToken({@Bind.query('duration') int duration})async{
    if(duration != null){
      _duration = duration;
    }
    final int _validTill = (DateTime.now().millisecondsSinceEpoch/1000 + _duration).floor();

    const String _collection = usersCollection;
    final String _ownerId = request.authorization.clientID;
    final TokenModel _tokenModel = TokenModel(
      collection: _collection,
      ownerId: _ownerId,
      validTill: _validTill,
    );

    final Map<String, dynamic> _dbRes = await _tokenModel.save();
    
    if(_dbRes['status'] == 0){
      final Map<String, dynamic> _responseBody = {
          "body": {
            "token": _tokenModel.token,
            "validTill": _validTill,
          }
        };
        return Response.ok(_responseBody);
    } else {
      final Map<String, dynamic> _responseBody = {"body": "an error occured."};
      return Response.serverError(body: _responseBody);
    }
  }
    
}

