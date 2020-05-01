import 'package:maziwa_otp/businesses/models/business_model.dart';
import 'package:maziwa_otp/maziwa_otp.dart';

class BusinessesDeleteController extends ResourceController{
  final BusinessModel businessModel = BusinessModel();

  @Operation.get('businessId')
  Future<Response> fetchByEmail(@Bind.path('businessId') String businessId)async{
    ObjectId _id;
    try {
      _id = ObjectId.parse(businessId);
    } catch (e) {
      _id = ObjectId();
    }
    final Map<String, dynamic> _dbRes = await businessModel.remove(where.id(_id));
    if(_dbRes['status'] == 0){
      return Response.ok({"body": "Business deleted"});
    } else{
      return Response.serverError(body: {"error": "An error occurred!"});
    }
  }




}