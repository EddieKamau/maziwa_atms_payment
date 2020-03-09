import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/users/models/users_models.dart' show UserModel;
import 'package:maziwa_otp/users/serializers/users_serializers.dart' show UserCreateSerializer;

class UserController extends ResourceController{

  Response response = Response.serverError();

  @Operation.post()
  Future<Response> createUser(@Bind.body(require: ['email', 'password']) UserCreateSerializer userCreateSerializer)async{
    final UserModel userModel = UserModel(
      email: userCreateSerializer.email,
      password: userCreateSerializer.password
    );

    final Map<String, dynamic> _dbRes = await userModel.save();

    if(_dbRes['status'] == 0){
      response = Response.accepted();
    }

    return response;
  }

}