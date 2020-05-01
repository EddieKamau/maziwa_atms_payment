import 'package:maziwa_otp/users/models/users_models.dart' show UserModel, where, ObjectId;

Future<String> userEmailById(String id)async{
  final UserModel userModel = UserModel();
  ObjectId _id;
  try {
    _id = ObjectId.parse(id);
  } catch (e) {
    _id = ObjectId();
  }

  final Map<String, dynamic> _dbRes = await userModel.findOneBy(
    where.id(_id).fields(['email'])
  );
  if(_dbRes['status'] == 0){
    if(_dbRes['body'] != null){
      return _dbRes['body']['email'].toString();
    }else{
      return null;
    }

  }else{
    return null;
  }

}