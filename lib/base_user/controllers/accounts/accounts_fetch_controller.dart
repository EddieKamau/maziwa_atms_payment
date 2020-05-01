import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/users/models/users_models.dart';

class UserFetchController extends ResourceController{
  final UserModel userModel = UserModel();

  @Operation.get()
  Future<Response> fetchAll()async{
    final Map<String, dynamic> _dbRes = await userModel.find(where.excludeFields(['password']));
    if(_dbRes['status'] == 0){
      return Response.ok(_dbRes);
    } else{
      return Response.serverError(body: {"error": "An error occurred!"});
    }
  }

  @Operation.get('email')
  Future<Response> fetchByEmail(@Bind.path('email') String email)async{
    final Map<String, dynamic> _dbRes = await userModel.findOneBy(where.eq('email', email).excludeFields(['password']));
    if(_dbRes['status'] == 0){
      return Response.ok(_dbRes);
    } else{
      return Response.serverError(body: {"error": "An error occurred!"});
    }
  }




}