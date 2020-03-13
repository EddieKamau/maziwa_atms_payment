import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/sms/models/sms_models.dart' show SmsModel, where;

class SmsReportsController extends ResourceController{

  Response response = Response.serverError();
  final SmsModel smsModel = SmsModel();

  @Operation.get('businessId')
  Future<Response> fetchSmsReports(@Bind.path('businessId') String businessId)async{

    final Map<String, dynamic> _dbRes = await smsModel.findBySelector(
      where.eq('businessId', businessId)
    );

    if(_dbRes['status'] == 0){
      response = Response.ok(_dbRes['body']);
    }

    return response;
  }

}