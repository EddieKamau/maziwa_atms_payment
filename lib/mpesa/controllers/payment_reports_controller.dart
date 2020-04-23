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


class PaymentsTotals extends ResourceController{

  Response response = Response.serverError();
  final MpesaConfirmationModel mpesaConfirmationModel = MpesaConfirmationModel();

  @Operation.get('businessId')
  Future<Response> fetchSmsReports(@Bind.path('businessId') String businessId)async{
    double _total = 0;

    final Map<String, dynamic> _dbRes = await mpesaConfirmationModel.findBySelector(
      where.eq('businessId', businessId), fields: ['TransAmount']
    );

    if(_dbRes['status'] == 0){
      if(_dbRes['body'] != null){
        _dbRes['body'].forEach((value){
          _total += double.parse(value['TransAmount'].toString());
        });
      }

      response = Response.ok({"totalAmount": _total});
    }

    return response;
  }

}

