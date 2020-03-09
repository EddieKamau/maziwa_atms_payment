import 'package:maziwa_otp/models/model.dart';

export 'package:maziwa_otp/models/model.dart' show ObjectId;

class MpesaValidationModel extends Model{
  MpesaValidationModel({this.body})
      :super(dbUrl: databaseUrl, collectionName: mpesaValidationsCollection){
        document = body;
      }

  final Map<String, dynamic> body;
}