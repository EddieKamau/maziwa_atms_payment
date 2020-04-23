import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/otp/models/otp_models.dart';

class OtpsAmountController extends ResourceController{

  Response response = Response.serverError();
  final OtpModel otpModel = OtpModel();

  @Operation.get('businessId')
  Future<Response> fetchOtps(@Bind.path('businessId') String businessId, {@Bind.query("filter") String filter})async{
    double _total = 0;

    final Map<String, dynamic> _dbRes = await otpModel.findBySelector(
      filter == 'active' ? 
      where.eq('businessId', businessId).eq('active', true) :
        filter == 'inactive' ? 
        where.eq('businessId', businessId).eq("active", false) :
      where.eq('businessId', businessId)
    );

    if(_dbRes['status'] == 0){
      if(_dbRes['body'] != null){
        _dbRes['body'].forEach((value){
          _total += double.parse(value['amount'].toString());
        });
      }


      response = Response.ok(_total);
    }

    return response;
  }

}