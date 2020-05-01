import 'package:maziwa_otp/base_user/models/base_user_models.dart';
import 'package:maziwa_otp/base_user/requests/requests_manager.dart';
import 'package:maziwa_otp/base_user/serializers/base_user_serializers.dart';
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/response/models/response_models.dart';

class BaseUserEditRoleController extends ResourceController{
  BaseUserModel userModel = BaseUserModel();

  String _requestId;
  final ResposeType _responseType = ResposeType.baseUser;
  ResponsesStatus _responseStatus;
  dynamic _responseBodyModel;
  Map<String, dynamic> _responseBody;

  @Operation.post('userId')
  Future<Response> updateRole(
    @Bind.path('userId') String userId,
    @Bind.body(require: ['role']) UsersSerializer usersSerializer)async{

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

      final Map<String, dynamic> _dbRes = await userModel.findAndModify(
        selector: where.id(ObjectId.parse(userId)),
        modifier: modify.set('role', usersSerializer.role)
        );
      if(_dbRes['status'] == 0){
        _responseStatus = ResponsesStatus.success;
        _responseBody = {"body": "role updated successfully"};
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
 