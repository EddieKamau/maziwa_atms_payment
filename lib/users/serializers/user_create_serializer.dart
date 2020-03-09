import 'package:maziwa_otp/maziwa_otp.dart';

class UserCreateSerializer extends Serializable{
  String email;
  String password;
  @override
  Map<String, dynamic> asMap() => {
    'email': email,
    'password': password
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    email = object['email'].toString();
    password = object['password'].toString();
  }

}