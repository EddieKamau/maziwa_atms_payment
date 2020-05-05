import 'package:maziwa_otp/businesses/modules/business_price_list_module.dart';
import 'package:maziwa_otp/mpesa/models/mpesa_models.dart' show MpesaValidationModel, ObjectId;

Future<bool> mpesaValidationModule(Map<String, dynamic> _body, String businessId)async{
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

  return accept;
}