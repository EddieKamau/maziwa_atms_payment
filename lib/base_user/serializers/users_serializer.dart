import 'package:maziwa_otp/maziwa_otp.dart';

class UsersSerializer extends Serializable {
  String email;
  String role;
  String password;

  @override
  Map<String, dynamic> asMap() {
    return {
      'email': email,
      'password': password,
      'role': role,
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    email = object['email'].toString();
    role = object['role'].toString();
    password = object['password'].toString();
  }

  @override
  void read(Map<String, dynamic> object, {Iterable<String> ignore, Iterable<String> reject, Iterable<String> require}) {
    final List<String> _reject= reject == null ? [] : reject.toList();
    final String _email = object['email'].toString();
    final String _role = object['role'].toString().toLowerCase();
    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)){
      _reject.add('email');
    }

    if(
      _role == 'moderator' ||
      _role == 'normal' ||
      _role == 'guest' ||
      _role == 'anonymous'
    ){
    } else{
       _reject.add('role');
    }


    super.read(object, ignore: ignore, reject: _reject, require: require);
  }

}