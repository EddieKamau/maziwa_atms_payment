import 'package:maziwa_otp/models/model.dart';
import 'package:random_string/random_string.dart';
export 'package:maziwa_otp/models/model.dart' 
        show where, modify, ObjectId, 
        tokensCollection, usersCollection;

class TokenModel extends Model{
  TokenModel({
    this.collection,
    this.ownerId,
    this.validTill
  }): super(dbUrl: databaseUrl, collectionName: tokensCollection){
    token = randomAlphaNumeric(20);
    super.document = asMap();
  }

  String token;
  final String collection;
  final String ownerId;
  final int validTill;

  Map<String, dynamic> asMap() =>{
    'token': token,
    'collection': collection,
    'ownerId': ownerId,
    'validTill': validTill
  };

  TokenModel fromMap(Map<String, dynamic> obj)=> TokenModel(
    collection: obj['collection'].toString(), 
    ownerId: obj['ownerId'].toString(), 
    validTill: int.parse(['validTill'].toString()), 
  ); 
}