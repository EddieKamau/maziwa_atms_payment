import 'package:maziwa_otp/models/model.dart';
import 'package:password/password.dart';

export 'package:maziwa_otp/models/model.dart' show where, modify, ObjectId;

class UserModel extends Model{
  UserModel({this.email, this.password, this.active})
            :super(dbUrl: databaseUrl, collectionName: usersCollection){
              // hash passord
              hash = Password.hash(password?? '', PBKDF2());
              active ??= true;

              document = asMap();

            }

  final String email;
  final String password;
  bool active;
  String hash;

  Map<String, String> asMap()=>{
    'email': email,
    'password': hash
  };

  Future<bool> verifyPassword()async{
    final Map<String, dynamic> _dbRes =await findOneBy(where.eq('email', email), fields: ['password']);
    if(_dbRes['status'] == 0){
      try {
        final String _hash = _dbRes['body']['password'].toString();
        return Password.verify(password, _hash);
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
    
  }

}
