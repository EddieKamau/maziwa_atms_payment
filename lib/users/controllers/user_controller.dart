import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/registration_token/models/registration_token_models.dart';
import 'package:maziwa_otp/users/models/users_models.dart' show UserModel;
import 'package:maziwa_otp/users/serializers/users_serializers.dart' show UserCreateSerializer;

class UserController extends ResourceController{
  final RegitrationTokenModel regitrationTokenModel = RegitrationTokenModel();

  Response response = Response.serverError();

  @Operation.post()
  Future<Response> createUser(@Bind.body(require: ['email', 'password']) UserCreateSerializer userCreateSerializer)async{
    final UserModel userModel = UserModel(
      email: userCreateSerializer.email,
      password: userCreateSerializer.password
    );

    final Map<String, dynamic> _dbRes = await userModel.save();

    if(_dbRes['status'] == 0){
      // update registration token
      await regitrationTokenModel.findAndModify(
        selector: where.eq('token', request.authorization.clientID),
        modifier: modify.set('used', true)
      );

      response = Response.accepted();
    } else if(_dbRes['body']['code'] == 11000){
      response = Response.badRequest(body: {"error": "account exist!"});
    }

    return response;
  }

}