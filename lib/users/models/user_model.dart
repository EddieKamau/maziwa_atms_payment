import 'package:maziwa_otp/models/model.dart';
import 'package:password/password.dart';

class UserModel extends Model{
  UserModel({this.email, this.password})
            :super(dbUrl: databaseUrl, collectionName: usersCollection){
              // hash passord
              hash = Password.hash(password, PBKDF2());

              document = asMap();

            }

  final String email;
  final String password;
  String hash;

  Map<String, String> asMap()=>{
    'email': email,
    'password': hash
  };

  Future<bool> verifyPassword()async{
    final Map<String, dynamic> _dbRes =await findOneBy(where.eq('email', email), fields: ['password']);
    if(_dbRes['status'] == 0){
      final String _hash = _dbRes['body']['password'].toString();
      return Password.verify(password, _hash);
    } else {
      return false;
    }
    
  }

}