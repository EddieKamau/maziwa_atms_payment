import "package:maziwa_otp/maziwa_otp.dart";

class MailServerConfSerializer extends Serializable{
  String host;
  int port;
  String name;
  String username;
  String password;
  String activateAccountSubject;
  String activateAccountBody;
  String creatAccountSubject;
  String creatAccountBody;
  String resetAccountSubject;
  String resetAccountBody;
  @override
  Map<String, dynamic> asMap()=>{
    "host": host,
    "port": port,
    "name": name,
    "username": username,
    "password": password,
    "activateAccountSubject": activateAccountSubject,
    "activateAccountBody": activateAccountBody,
    "creatAccountSubject": creatAccountSubject,
    "creatAccountBody": creatAccountBody,
    "resetAccountSubject": resetAccountSubject,
    "resetAccountBody": resetAccountBody
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    host = object["host"]?.toString();
    port = int.parse(object["port"].toString());
    name = object["name"]?.toString();
    username = object["username"]?.toString();
    password = object["password"]?.toString();
    activateAccountSubject = object["activateAccountSubject"]?.toString();
    activateAccountBody = object["activateAccountBody"]?.toString();
    creatAccountSubject = object["creatAccountSubject"]?.toString();
    creatAccountBody = object["creatAccountBody"]?.toString();
    resetAccountSubject = object["resetAccountSubject"]?.toString();
    resetAccountBody = object["resetAccountBody"]?.toString();
  }

}