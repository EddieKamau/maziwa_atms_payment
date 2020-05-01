import 'package:maziwa_otp/businesses/modules/business_price_list_module.dart';
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mpesa/models/mpesa_models.dart' show MpesaValidationModel, ObjectId;

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
    
    bool accept = true;

    final List<double> _lst = await getPriceListbyBusinessId(businessId); 
    if(_lst == null){
      accept = true;
    } else{
      if(_lst.contains(double.parse(_body['TransAmount'].toString()))){
        accept = true;
      } else{
        accept = false;
      }
    }

    final String _transId = ObjectId().toJson();
    _body['transId'] = _transId;
    _body['businessId'] = businessId;
    _body['accepted'] = accept;

    final MpesaValidationModel _mpesaValidationModel = MpesaValidationModel(body: _body);
    await _mpesaValidationModel.save();

    return Response.ok({
      "ResultCode": accept ? 0 : 1,
      "ResultDesc": accept ? "Validation Received Successfully" : "Validation rejected",
      // "ThirdPartyTransID": _transId
      "ThirdPartyTransID": businessId
    });
  }

  


}