import 'package:maziwa_otp/models/model.dart';

class MpesaConfirmationModel extends Model{
  MpesaConfirmationModel({this.body})
      :super(dbUrl: databaseUrl, collectionName: mpesaConfirmationsCollection){
        document = body;
      }

  final Map<String, dynamic> body;
}