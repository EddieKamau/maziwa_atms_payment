import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mpesa/models/mpesa_models.dart' show MpesaConfirmationModel, where;

class PaymentsReportsController extends ResourceController{

  Response response = Response.serverError();
  final MpesaConfirmationModel mpesaConfirmationModel = MpesaConfirmationModel();

  @Operation.get('businessId')
  Future<Response> fetchSmsReports(@Bind.path('businessId') String businessId)async{

    final Map<String, dynamic> _dbRes = await mpesaConfirmationModel.findBySelector(
      where.eq('businessId', businessId)
    );

    if(_dbRes['status'] == 0){
      response = Response.ok(_dbRes['body']);
    }

    return response;
  }

}