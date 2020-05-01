
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/token/models/token_model.dart' show TokenModel, where, modify;

class BaseUserLogOutController extends ResourceController{
  final TokenModel _tokenModel = TokenModel();

  @Operation.get()
  Future<Response> logout()async{
    final String _token = request.authorization.credentials?.username;

    final Map<String, dynamic> _dbRes = await _tokenModel.findAndModify(
      selector: where.eq('token', _token),
      modifier: modify.set('validTill', 0)
    );

    if(_dbRes['status'] == 0){
      return Response.accepted();
    } else {
      return Response.serverError(body: {"body": "an error occured."});
    }

  }
}