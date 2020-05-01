import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mpesa/models/mpesa_models.dart' show MpesaValidationModel, where;

class BusinessesPaymentsValidationsReportsController extends ResourceController{

  Response response = Response.serverError();
  final MpesaValidationModel mpesaValidationModel = MpesaValidationModel();

  @Operation.get()
  Future<Response> fetchSmsReports({@Bind.query('filter') String filter})async{


    final Map<String, dynamic> _dbRes = await mpesaValidationModel.findBySelector(
      filter == 'accepted' ?
      where.ne('accepted', false) :
        filter == 'rejected' ?
        where.eq('accepted', false) :
      null
    );

    if(_dbRes['status'] == 0){
      response = Response.ok(_dbRes['body']);
    }

    return response;
  }

  @Operation.get('businessId')
  Future<Response> fetchSmsReportsByBusinessId(@Bind.path('businessId') String businessId, {@Bind.query('filter') String filter})async{


    final Map<String, dynamic> _dbRes = await mpesaValidationModel.findBySelector(
      filter == 'accepted' ?
      where.eq('businessId', businessId).ne('accepted', false) :
        filter == 'rejected' ?
        where.eq('businessId', businessId).eq('accepted', false) :
      where.eq('businessId', businessId)
    );

    if(_dbRes['status'] == 0){
      response = Response.ok(_dbRes['body']);
    }

    return response;
  }

  

}

