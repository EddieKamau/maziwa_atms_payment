import 'package:maziwa_otp/models/model.dart';

class SmsModel extends Model{
  SmsModel({this.body, this.phoneNo})
          :super(dbUrl: databaseUrl, collectionName: smsCollection){
            document = asMap();
          }

  final String phoneNo;
  final String body;

  Map<String, String> asMap()=>{
    'phoneNo': phoneNo,
    'body': body
  };


}