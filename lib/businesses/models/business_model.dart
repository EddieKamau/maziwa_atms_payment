import 'package:maziwa_otp/models/model.dart';

export 'package:maziwa_otp/models/model.dart' show where, ObjectId, modify;

class BusinessModel extends Model{
  BusinessModel({this.consumerKey, this.consumerSecret, this.label, this.ownerId, this.shortCode})
                :super(dbUrl: databaseUrl, collectionName: businessesCollection){
                  _id = ObjectId();

                  document = asMap();
                }


  final String ownerId;
  final String label;
  final String shortCode;
  final String consumerKey;
  final String consumerSecret;

  ObjectId _id;

  String get id => _id.toJson();

  Map<String, dynamic> asMap()=> {
    '_id': _id,
    'ownerId': ownerId,
    'consumerKey': consumerKey,
    'consumerSecret': consumerSecret,
    'label': label,
    'shortCode': shortCode,
  };

}