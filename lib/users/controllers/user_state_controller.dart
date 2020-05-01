import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/users/models/users_models.dart';
import 'package:maziwa_otp/users/serializers/users_serializers.dart';

class UserStateController extends ResourceController{
  final UserModel userModel = UserModel();

  @Operation.put('email')
  Future<Response> changestate(@Bind.body(require: ['active']) UserCreateSerializer userCreateSerializer, @Bind.path('email') String email)async{
    final Map<String, dynamic> _dbRes = await userModel.findAndModify(
      selector: where.eq('email', email),
      modifier: modify.set('active', userCreateSerializer.active)
    );

    if(_dbRes['status'] == 0){
      if(_dbRes['body'] != null){
        return Response.ok({'body': "status updated!"});
      } else{
        return Response.badRequest(body: {'body': "invalid email (account)"});
      }
    } else{
      return Response.serverError(body: {"error": "An error occurred!"});
    }
  }


}