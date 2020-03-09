import 'package:maziwa_otp/maziwa_otp.dart';

class BusinessCreateSerializer extends Serializable{
  String label;
  String shortCode;
  String consumerKey;
  String consumerSecret;

  @override
  Map<String, dynamic> asMap() => {
    'consumerKey': consumerKey,
    'consumeSecret': consumerSecret,
    'label': label,
    'shortCode': shortCode,
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    label = object['label'].toString();
    shortCode = object['shortCode'].toString();
    consumerKey = object['consumerKey'].toString();
    consumerSecret = object['consumerSecret'].toString();
  }
}