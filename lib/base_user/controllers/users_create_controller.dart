import 'package:maziwa_otp/base_user/models/base_user_models.dart';
import 'package:maziwa_otp/base_user/requests/requests_manager.dart';
import 'package:maziwa_otp/base_user/serializers/base_user_serializers.dart';
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mail_server/models/mail_server_models.dart' show MailServerModel, MailType;
import 'package:maziwa_otp/response/models/response_models.dart';
import 'package:random_string/random_string.dart';

class BaseUserCreateController extends ResourceController{
  BaseUserModel userModel = BaseUserModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.baseUser;
  ResponsesStatus _responseStatus;
  dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;
  final String _password = randomAlphaNumeric(10);

  @Operation.post()
  Future<Response> createUser(@Bind.body(require: ['email', 'role']) UsersSerializer usersSerializer)async{
    String _email;
    final Map<String, dynamic> _dbResUser = await userModel.findById(request.authorization.clientID, fields: ['email']);
    if(_dbResUser['status'] == 0){
      _email  = _dbResUser['body']['email'].toString();
    }
    // Save request 
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: _email,
      baseUserRequestsType: BaseUserRequestsType.create,
      metadata: usersSerializer.asMap(),
    );
    _baseUserRequests.normalRequest();
    _requestId = _baseUserRequests.requestId();


    final BaseUserModel _userModel = BaseUserModel(
      email: usersSerializer.email,
      password: null,
      tempPassword: _password,
      role: userModel.userRoleFromString(usersSerializer.role.toLowerCase())
    );
    try{
      final Map<String, dynamic> _dbRes = await _userModel.save();
      if(_dbRes['status'] == 0){

        // send mail
        final MailServerModel mailServerModel = MailServerModel();
        final bool _sent = await mailServerModel.sendMail(
          MailType.accountCreate, 
          "Use the password below to activate your account! \nPassword: $_password", 
          usersSerializer.email
        );
        if(_sent){
          _responseStatus = ResponsesStatus.success;
          _responseBody = {'body': "User saved."};
        }else{
          _responseStatus = ResponsesStatus.warning;
          _responseBody = {'body': "User saved. Error sending credetials"};
        }


        
      } else {
        if(_dbRes['body']['code'] == 11000){
          _responseStatus = ResponsesStatus.warning;
          _responseBody = {'body': "email exixts"};
        } else {
          _responseStatus = ResponsesStatus.error;
          _responseBody = {'body': 'An error occured!'};
        }
      }
    }catch (e){
      _responseStatus = ResponsesStatus.error;
      _responseBody =  {'body': 'An error occured!'};
    }

    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse(_responseBody);

  }

  @Operation.delete('userId')
  Future<Response> delete(@Bind.path("userId") String userId)async{
    String _email;
    final Map<String, dynamic> _dbResUser = await userModel.findById(request.authorization.clientID, fields: ['email']);
    if(_dbResUser['status'] == 0){
      _email  = _dbResUser['body']['email'].toString();
    }
    // Save request 
    final BaseUserRequests _baseUserRequests = BaseUserRequests(
      account: _email,
      baseUserRequestsType: BaseUserRequestsType.delete,
      metadata: {
        "function": 'Delete one users',
        "userId": userId
      },
    );
    _baseUserRequests.normalRequest();
    _requestId = _baseUserRequests.requestId();


    final Map<String, dynamic> _dbRes = await userModel.remove(where.id(ObjectId.parse(userId)));
      if(_dbRes['status'] == 0){
        _responseStatus = ResponsesStatus.success;
        _responseBody = {"body": "deleted successfully"};
      } else {
        _responseStatus = ResponsesStatus.success;
        _responseBody = {"body": "invalid id"};
      }
    // Save response
    final ResponsesModel _responsesModel = ResponsesModel(requestId: _requestId, responseType: _responseType, status: _responseStatus, responseBody: _responseBodyModel != null ? _responseBodyModel : _responseBody);
    await _responsesModel.save();
    return _responsesModel.sendResponse(_responseBody);
  }


}