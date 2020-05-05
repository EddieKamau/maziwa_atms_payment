import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mpesa/models/mpesa_models.dart' show MpesaValidationModel, ObjectId;
import 'package:maziwa_otp/mpesa/modules/mpesa_modules.dart' show mpesaValidationModule;

class MpesaValidationController extends ResourceController{

  @Operation.post()
  Future<Response> mpesaValidation()async{
    final Map<String, dynamic> _body = await request.body.decode<Map<String, dynamic>>();

    final String _transId = ObjectId().toJson();
    _body['transId'] = _transId;

    final MpesaValidationModel _mpesaValidationModel = MpesaValidationModel(body: _body);
    await _mpesaValidationModel.save();

    return Response.ok({
      "ResultCode": 0,
      "ResultDesc": "Validation Received Successfully",
      "ThirdPartyTransID": _transId
    });
  }

  @Operation.post('businessId')
  Future<Response> mpesaValidationByBusiness(@Bind.path('businessId') String businessId)async{

    final Map<String, dynamic> _body = await request.body.decode<Map<String, dynamic>>();

    final bool accept = await mpesaValidationModule(_body, businessId);    
    

    return Response.ok({
      "ResultCode": accept ? 0 : 1,
      "ResultDesc": accept ? "Validation Received Successfully" : "Validation rejected",
      // "ThirdPartyTransID": _transId
      "ThirdPartyTransID": businessId
    });
  }

  


}