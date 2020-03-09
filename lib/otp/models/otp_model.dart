import 'dart:math';

import 'package:maziwa_otp/models/model.dart';

class OtpModel extends Model{

  OtpModel({this.refNo})
          :super(dbUrl: databaseUrl, collectionName: otpCollection){
            // generate otp
            final Random random = Random();
            otp = '${1000 + random.nextInt(1000)}';

            // generate vallidTill
            vallidTill = DateTime.now().millisecondsSinceEpoch + 1800000;
          }


  final String refNo;
  String otp;
  int vallidTill;
  bool active;

  Map<String, dynamic> asMap()=>{
    'active': active,
    'vallidTill': vallidTill,
    'otp': otp,
    'refNo': refNo
  };
}