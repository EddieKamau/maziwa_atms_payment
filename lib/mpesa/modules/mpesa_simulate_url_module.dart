import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maziwa_otp/mpesa/configs/mpesa_configs.dart';
import 'package:maziwa_otp/mpesa/modules/mpesa_modules.dart' show fetchMpesaToken;


Future<http.Response> mpesaSimulateModule({
  String shortCode,
  String amount,
  String phoneNo,
  String refNo,
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
    "ShortCode": shortCode,
    "CommandID": "CustomerPayBillOnline",
    "Amount": amount,
    "Msisdn": phoneNo,
    "BillRefNumber": refNo
  };

  try{
    return await http.post(mpesaSimulateUrL, headers: _headers, body: json.encode(_payload));

  } catch (e){
    return null;
  }

}