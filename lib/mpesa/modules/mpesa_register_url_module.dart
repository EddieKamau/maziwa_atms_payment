import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maziwa_otp/mpesa/configs/mpesa_configs.dart';
import 'package:maziwa_otp/mpesa/modules/mpesa_modules.dart' show fetchMpesaToken;


Future<http.Response> mpesaRegisterUrlModule({
  String shortCode,
  String businessId,
  String consumerKey,
  String consumerSecret,
})async{

  final Map<String, dynamic> _tokenRes = await fetchMpesaToken(key: consumerKey, secret: consumerSecret);

  if(_tokenRes['status'] != 0){
    return null;
  }

  final String accessToken = _tokenRes['body']['token'].toString();

  final Map<String, String> _headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer $accessToken'
  };

  final Map<String, dynamic> _payload = {
    "ShortCode": shortCode ,
    "ResponseType": "Completed",
    "ConfirmationURL": "$mpesaNotificationUrl/confirmation/$businessId",
    "ValidationURL": "$mpesaNotificationUrl/validate/$businessId"
  };

  try{
    return await http.post(mpesaRegisterUrL, headers: _headers, body: json.encode(_payload));

  } catch (e){
    return null;
  }

}