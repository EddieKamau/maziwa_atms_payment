import 'package:maziwa_otp/businesses/models/business_model.dart';
import 'package:maziwa_otp/maziwa_otp.dart';

class BusinessesFetchController extends ResourceController{
  final BusinessModel businessModel = BusinessModel();

  @Operation.get()
  Future<Response> fetchAll({@Bind.query('shortCode') String shortCode})async{
    final Map<String, dynamic> _dbRes = await businessModel.find(
      shortCode != null ?
      where.eq('shortCode', shortCode) :
      null
    );
    if(_dbRes['status'] == 0){
      return Response.ok(_dbRes);
    } else{
      return Response.serverError(body: {"error": "An error occurred!"});
    }
  }

  @Operation.get('businessId')
  Future<Response> fetchByBusinessId(@Bind.path('businessId') String businessId)async{
    ObjectId _id;
    try {
      _id = ObjectId.parse(businessId);
    } catch (e) {
      _id = ObjectId();
    }
    final Map<String, dynamic> _dbRes = await businessModel.findOneBy(where.id(_id));
    if(_dbRes['status'] == 0){
      return Response.ok(_dbRes);
    } else{
      return Response.serverError(body: {"error": "An error occurred!"});
    }
  }




}