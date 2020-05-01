import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/users/models/users_models.dart';

class UserDeleteController extends ResourceController{
  final UserModel userModel = UserModel();

  @Operation.delete('email')
  Future<Response> deleteByEmail(@Bind.path('email') String email)async{
    final Map<String, dynamic> _dbRes = await userModel.remove(where.eq('email', email));
    if(_dbRes['status'] == 0){
      return Response.ok({"body": "Account deleted"});
    } else{
      return Response.serverError(body: {"error": "An error occurred!"});
    }
  }




}