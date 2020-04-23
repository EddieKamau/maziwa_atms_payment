import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/otp/models/otp_models.dart';

class FetchOtpsController extends ResourceController{

  Response response = Response.serverError();
  final OtpModel otpModel = OtpModel();

  @Operation.get('businessId')
  Future<Response> fetchOtps(@Bind.path('businessId') String businessId)async{

    final Map<String, dynamic> _dbRes = await otpModel.findBySelector(
      where.eq('businessId', businessId)
    );

    if(_dbRes['status'] == 0){
      response = Response.ok(_dbRes['body']);
    }

    return response;
  }

}