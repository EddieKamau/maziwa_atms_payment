import 'package:maziwa_otp/models/model.dart';

export 'package:maziwa_otp/models/model.dart' show where;

class SmsModel extends Model{
  SmsModel({this.body, this.phoneNo, this.businessId})
          :super(dbUrl: databaseUrl, collectionName: smsCollection){
            document = asMap();
          }

  final String phoneNo;
  final String body;
  final String businessId;

  Map<String, String> asMap()=>{
    'phoneNo': phoneNo,
    'body': body,
    'businessId': businessId,
  };


}