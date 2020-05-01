import 'package:maziwa_otp/maziwa_otp.dart';

class UserCreateSerializer extends Serializable{
  String email;
  String password;
  bool active;
  @override
  Map<String, dynamic> asMap() => {
    'email': email,
    'password': password,
    'active': active,
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    email = object['email'].toString();
    password = object['password'].toString();
    active = object['active'] == true;
  }

  @override
  void read(Map<String, dynamic> object, {Iterable<String> ignore, Iterable<String> reject, Iterable<String> require}) {
    final List<String> _reject= reject == null ? [] : reject.toList();
    final String _email = object['email'].toString();
    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)){
      _reject.add('email');
    }

    super.read(object, ignore: ignore, reject: _reject, require: require);
  }

}