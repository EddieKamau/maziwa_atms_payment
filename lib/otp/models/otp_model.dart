import 'dart:math';

import 'package:maziwa_otp/models/model.dart';

export 'package:maziwa_otp/models/model.dart' show where, modify, ObjectId;

class OtpModel extends Model{

  OtpModel({this.refNo, this.shortCode, this.amount, this.businessId})
          :super(dbUrl: databaseUrl, collectionName: otpCollection){
            // generate otp
            final Random random = Random();
            otp = '${1000 + random.nextInt(1000)}';

            // generate vallidTill
            vallidTill = DateTime.now().millisecondsSinceEpoch + 1800000;

            document = asMap();
          }


  final String amount;
  final String refNo;
  final String shortCode;
  final String businessId;
  String otp;
  int vallidTill;
  bool active = true;

  Map<String, dynamic> asMap()=>{
    'businessId': businessId,
    'active': active,
    'amount': amount,
    'vallidTill': vallidTill,
    'otp': otp,
    'refNo': refNo,
    'shortCode': shortCode,
  };
}