import 'package:maziwa_otp/base_user/requests/requests_manager.dart';
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/models/utils/database_collection_names.dart' show baseUserCollection;
import 'package:maziwa_otp/response/models/response_models.dart';
import 'package:maziwa_otp/token/models/token_model.dart';

class BaseUserTokenController extends ResourceController{
  TokenModel tokenModel = TokenModel();
  static int _duration = 300; // 300 seconds for 5 mins
  

  String _requestId;
  final ResposeType _responseType = ResposeType.baseUser;
  ResponsesStatus _responseStatus;
  Map<String, dynamic> _responseBody;

  @Operation.get()
  Future<Response> getBaseUserToken({@Bind.query('duration') int duration})async{
    if(duration != null){
      _duration = duration;
    }
    final int _validTill = (DateTime.now().millisecondsSinceEpoch/1000 + _duration).floor();
    // Save request 
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: request.authorization != null ? request.authorization.clientID : null,
      baseUserRequestsType: BaseUserRequestsType.login,
      metadata: {
        "function": 'User login/ get token',
        "userId": request.authorization.clientID
      },
    );
    _baseUserRequests.normalRequest();
    _requestId = _baseUserRequests.requestId();

    const String _collection = baseUserCollection;
    final String _ownerId = request.authorization.clientID;
    final TokenModel _tokenModel = TokenModel(
      collection: _collection,
      ownerId: _ownerId,
      validTill: _validTill,
    );

    final Map<String, dynamic> _dbRes = await _tokenModel.save();
    
    if(_dbRes['status'] == 0){
      _responseStatus = ResponsesStatus.success;
      _responseBody = {
          
          "body": {
            "token": _tokenModel.token,
            "validTill": _validTill,
          }
        };
    } else {
      _responseStatus = ResponsesStatus.error;
      _responseBody = {"body": "an error occured."};
    }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse(_responseBody);
  }
    
}

