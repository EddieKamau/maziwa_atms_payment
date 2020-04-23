import 'dart:math';

import 'package:maziwa_otp/models/model.dart';

export 'package:maziwa_otp/models/model.dart' show where, modify, ObjectId;

class OtpModel extends Model{

  OtpModel({this.refNo, this.shortCode, this.amount, this.businessId, this.mpesaTransId, this.paymentId})
          :super(dbUrl: databaseUrl, collectionName: otpCollection){
            // generate otp
            final Random random = Random();
            otp = '${1000 + random.nextInt(1000)}';

            // generate validTill
            // validTill = DateTime.now().millisecondsSinceEpoch + 1800000;
            timeStamp = DateTime.now().millisecondsSinceEpoch;

            document = asMap();
          }


  final String amount;
  final String refNo;
  final String shortCode;
  final String businessId;
  final String mpesaTransId;
  final String paymentId;
  String otp;
  // int validTill;
  int timeStamp;
  bool active = true;

  Map<String, dynamic> asMap()=>{
    'businessId': businessId,
    'active': active,
    'amount': amount,
    // 'validTill': validTill,
    'timeStamp': timeStamp,
    'otp': otp,
    'refNo': refNo,
    'shortCode': shortCode,
    'mpesaTransId': mpesaTransId,
    'paymentId': paymentId,
  };
}