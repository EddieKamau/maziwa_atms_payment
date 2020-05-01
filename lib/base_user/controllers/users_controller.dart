import 'package:maziwa_otp/base_user/models/base_user_models.dart';
import 'package:maziwa_otp/base_user/requests/requests_manager.dart';
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/response/models/response_models.dart';

class BaseUserController extends ResourceController{
  BaseUserModel userModel = BaseUserModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.baseUser;
  ResponsesStatus _responseStatus;
  dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;

  @Operation.get()
  Future<Response> getAll({@Bind.query("email") String email})async{
    String _email;
    final Map<String, dynamic> _dbResUser = await userModel.findById(request.authorization?.clientID, fields: ['email']);
    if(_dbResUser['status'] == 0){
      _email  = _dbResUser['body']['email'].toString();
    }
    // save request
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: _email,
      baseUserRequestsType: BaseUserRequestsType.getAll,
      metadata: {
        "function": 'Get all users'
      },
    );
    _baseUserRequests.normalRequest();
    _requestId = _baseUserRequests.requestId();

    try{
      final Map<String, dynamic> _dbRes = await userModel.find(
        email == null ?
        where.excludeFields(['password', 'tempPassword']) :
        where.match('email', email).excludeFields(['password', 'tempPassword'])
      );
      _responseBodyModel = {
        'body': _dbRes['status'] == 0 ? _dbRes['body'].length : _dbRes['body'],
      };
      _responseBody = _dbRes;
      

      if(_dbRes['status'] == 0){
        _responseStatus = ResponsesStatus.success;
        _responseBody = _dbRes;
        
      } else {
        _responseBody = {"body": 'An error occured!'};
        _responseStatus = ResponsesStatus.failed;
      }
    }catch(e){
      _responseBody = {"body": 'An error occured!'};
      _responseStatus = ResponsesStatus.error;
    }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse(_responseBody);
    }

  @Operation.get('userId')
  Future<Response> getOne(@Bind.path("userId") String userId)async{
    String _email;
    final Map<String, dynamic> _dbResUser = await userModel.findById(request.authorization.clientID, fields: ['email']);
    if(_dbResUser['status'] == 0){
      _email  = _dbResUser['body']['email'].toString();
    }
    // Save request 
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: _email,
      baseUserRequestsType: BaseUserRequestsType.getByid,
      metadata: {
        "function": 'Get one users by userId',
        "userId": userId
      },
    );
    _baseUserRequests.normalRequest();
    _requestId = _baseUserRequests.requestId();


    try{
      final Map<String, dynamic> _dbRes = await userModel.findById(userId, exclude: ['password', 'tempPassword']);
      if(_dbRes['status'] == 0){
        _responseStatus = ResponsesStatus.success;
        _responseBody = _dbRes;
      } else {
        _responseStatus = ResponsesStatus.failed;
        _responseBody =  {"body": "invalid id"};
      }
    } catch (e){
      _responseStatus = ResponsesStatus.error;
      _responseBody = {"body": "An error occured!"};
    }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse(_responseBody);
  }

}