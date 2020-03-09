import 'package:maziwa_otp/maziwa_otp.dart';

class OtpVerifySerializer extends Serializable{
  String refNo;
  String otp;
  @override
  Map<String, dynamic> asMap() => {
    'refNo': refNo,
    'otp': otp
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    refNo = object['refNo'].toString();
    otp = object['otp'].toString();
  }

}