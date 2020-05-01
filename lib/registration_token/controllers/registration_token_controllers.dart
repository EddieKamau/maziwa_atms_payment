import 'package:maziwa_otp/base_user/models/base_user_models.dart';
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/registration_token/models/registration_token_models.dart';

class RegistrationTokenController extends ResourceController{
  final RegitrationTokenModel regitrationTokenModel = RegitrationTokenModel();
  final  BaseUserModel userModel = BaseUserModel();

  @Operation.post()
  Future<Response> generate()async{
    String _email;
    final Map<String, dynamic> _dbResUser = await userModel.findById(request.authorization?.clientID, fields: ['email']);
    if(_dbResUser['status'] == 0){
      _email  = _dbResUser['body']['email'].toString();
    }

    final RegitrationTokenModel _regitrationTokenModel = RegitrationTokenModel(
      issuerEmail: _email,
    );

    final Map<String, dynamic> _dbRes = await _regitrationTokenModel.save();

    if(_dbRes['status'] == 0){
      return Response.ok({'token': _regitrationTokenModel.token});
    }else{
      return Response.serverError(body: {'error': 'an error occurred!!'});
    }

  }

  @Operation.get()
  Future<Response> getAll({@Bind.query('token') String token})async{
    final Map<String, dynamic> _dbRes = await regitrationTokenModel.find(
      token != null ?
      where.eq('token', token) :
      null
    );

    if(_dbRes['status'] == 0){
      return Response.ok(_dbRes);
    }else{
      return Response.serverError(body: {'error': 'an error occurred!!'});
    }

  }

  @Operation.put('token')
  Future<Response> deactivate(@Bind.path('token') String token)async{
    final Map<String, dynamic> _dbRes = await regitrationTokenModel.findAndModify(
      selector: where.eq('token', token),
      modifier: modify.set('active', false)
    );

    if(_dbRes['status'] == 0){
      if(_dbRes['body'] != null){
        return Response.ok({'body': 'Token deactivated'});
      } else{
        return Response.badRequest(body: {'body': 'invalid token!'});
      }
    }else{
      return Response.serverError(body: {'error': 'an error occurred!!'});
    }
  }


}