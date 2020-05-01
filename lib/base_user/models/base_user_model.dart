import 'package:maziwa_otp/models/model.dart';
import 'package:password/password.dart';
export 'package:maziwa_otp/models/model.dart' show where, modify, ObjectId;

class BaseUserModel extends Model{

  BaseUserModel({
    this.email,
    this.password,
    this.tempPassword,
    this.role
  }):super(dbUrl: databaseUrl, collectionName: baseUserCollection){
    super.document = asMap();
  }

  final String email;
  final String password;
  final String tempPassword;
  final UserRole role;



  Map<String, dynamic> asMap (){
    return {
      'email': email,
      'password': Password.hash(password != null ? password : '', PBKDF2()),
      'tempPassword': Password.hash(tempPassword != null ? tempPassword : '', PBKDF2()),
      'role': role.value
    };
  }

  BaseUserModel fromMap (Map object) => BaseUserModel(
    email: object['email'].toString(),
    password: object['password'].toString(),
    tempPassword: object['tempPassword'].toString(),
    role: userRoleFromString(object['role'].toString()),
  );

  bool verifyPassword(String _password, String hash){
    if(hash == null){
      return false;
    }
    return Password.verify(_password, hash);
  }
  bool verifyTempPassword(String _tempPassword, String hash){
    if(hash == null){
      return false;
    }
    return Password.verify(_tempPassword, hash);
  }
  

  UserRole userRoleFromString(String value){
    switch (value) {
      case 'admin':
        return UserRole.admin;
        break;
      case 'moderator':
        return UserRole.moderator;
        break;
      case 'normal':
        return UserRole.normal;
        break;
      case 'guest':
        return UserRole.guest;
        break;
      case 'anonymous':
        return UserRole.anonymous;
        break;
      default:
        return UserRole.anonymous;
    }
  }
}

enum UserRole{
  admin,
  moderator,
  normal,
  guest,
  anonymous,
}

extension UserRoleValue on UserRole{
  String get value{
    switch (this) {
      case UserRole.admin:
        return 'admin';
        break;
      case UserRole.moderator:
        return 'moderator';
        break;
      case UserRole.normal:
        return 'normal';
        break;
      case UserRole.guest:
        return 'guest';
        break;
      case UserRole.anonymous:
        return 'anonymous';
        break;
      default:
        return 'anonymous';
    }
  }
}