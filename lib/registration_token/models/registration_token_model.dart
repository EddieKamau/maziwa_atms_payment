import 'package:maziwa_otp/models/model.dart';
import 'package:random_string/random_string.dart';

export 'package:maziwa_otp/models/model.dart' show where, modify;

class RegitrationTokenModel extends Model{
  RegitrationTokenModel({
    this.consumerEmail, this.issuerEmail, this.used
  }):super(dbUrl: databaseUrl, collectionName: registrationTokenCollection){
    token = randomAlpha(8);
    used ??= false;
    active ??= true;
    document = asMap();
  }


  String token;
  bool used;
  bool active;
  String issuerEmail;
  String consumerEmail;

  Map<String, dynamic> asMap()=>{
    'token': token,
    'used': used,
    'active': active,
    'issuerEmail': issuerEmail,
    'consumerEmail': consumerEmail,
  };
}