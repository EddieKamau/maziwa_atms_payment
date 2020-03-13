import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maziwa_otp/sms/configs/sms_configs.dart';
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/sms/models/sms_models.dart';

class SmsModule{
  SmsModule({this.body, this.phoneNo, this.businessId});

  final String phoneNo;
  final String body;
  final String businessId;

  Future<http.Response> jarvisSendSms()async{
    final _base64E = base64Encode(utf8.encode('$consumerKey:$consumeSecret'));
      final String basicAuth = 'Basic $_base64E';
    
      final Map<String, dynamic> _smsPayload = {
        'phoneNo': phoneNo,
        'message': body
      };
      try {
        return await http.post(jarvisSmsUrl, body: json.encode(_smsPayload), headers: <String, String>{'authorization': basicAuth, 'content-type': 'application/json'});
      } catch (e) {
        print(e);
        final http.Response _res = http.Response("An error Occured!!", 500,);
        return _res;
      }
    
  }

  Future save() async{
    final SmsModel smsModel = SmsModel(
      phoneNo: phoneNo,
      body: body,
      businessId: businessId
    );

    await smsModel.save();
    
  }

}