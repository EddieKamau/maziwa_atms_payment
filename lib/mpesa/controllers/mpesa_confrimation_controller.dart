import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mpesa/models/mpesa_models.dart' show MpesaConfirmationModel;

class MpesaConfirmationController extends ResourceController{

  @Operation.post()
  Future<Response> mpesaConfirmation()async{
    final Map<String, dynamic> _body = await request.body.decode<Map<String, dynamic>>();

    final MpesaConfirmationModel _mpesaConfirmationModel = MpesaConfirmationModel(body: _body);
    await _mpesaConfirmationModel.save();

    // final String _amount = _body['TransAmount'].toString();
    // final String _businessShortCode = _body['BusinessShortCode'].toString();
    // final String _phoneNo = _body['MSISDN'].toString();
    // final String _transID = _body['TransID'].toString();

    // send otp

    return Response.ok({
      "ResultCode": 0,
      "ResultDesc": "Confirmation Received Successfully"
    });
  }


}