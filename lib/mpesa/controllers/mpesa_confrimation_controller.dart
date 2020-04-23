import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mpesa/models/mpesa_models.dart' show MpesaConfirmationModel;
import 'package:maziwa_otp/otp/models/otp_models.dart' show OtpModel , ObjectId;
import 'package:maziwa_otp/sms/modules/sms_modules.dart' show SmsModule;

class MpesaConfirmationController extends ResourceController{

  @Operation.post()
  Future<Response> mpesaConfirmation()async{
    final Map<String, dynamic> _body = await request.body.decode<Map<String, dynamic>>();

    final MpesaConfirmationModel _mpesaConfirmationModel = MpesaConfirmationModel(body: _body);
    await _mpesaConfirmationModel.save();

    final String _amount = _body['TransAmount'].toString();
    final String _businessShortCode = _body['BusinessShortCode'].toString();
    final String _phoneNo = _body['MSISDN'].toString();
    final String _mpesaTransId = _body['TransID'].toString();

    // generate opt
    final OtpModel otpModel = OtpModel(
      amount: _amount,
      refNo: _phoneNo.substring(8),
      shortCode: _businessShortCode
    );
    await otpModel.save();

    // send otp
    final SmsModule smsModule = SmsModule(
      phoneNo: _phoneNo,
      body: '''
      Mpesa transaction $_mpesaTransId accepted for milk worth Ksh.$_amount
      \nPayment reference is: ${otpModel.refNo}. \nOTP is: ${otpModel.otp}
      \nThis OTP expires after 30 minutes.
      '''
    );
    // await smsModule.jarvisSendSms();

    await smsModule.save();

    return Response.ok({
      "ResultCode": 0,
      "ResultDesc": "Confirmation Received Successfully"
    });
  }

  @Operation.post('businessId')
  Future<Response> mpesaConfirmationByBusiness(@Bind.path('businessId') String businessId)async{
    final Map<String, dynamic> _body = await request.body.decode<Map<String, dynamic>>();
    
    // Save mpesa message
    final ObjectId _mpesaMessageId = ObjectId();
    final MpesaConfirmationModel _mpesaConfirmationModel = MpesaConfirmationModel(body: _body..['businessId'] = businessId ..['_id'] = _mpesaMessageId);
    await _mpesaConfirmationModel.save();

    final String _amount = _body['TransAmount'].toString();
    final String _businessShortCode = _body['BusinessShortCode'].toString();
    final String _phoneNo = _body['MSISDN'].toString();
    final String _mpesaTransId = _body['TransID'].toString();

    // generate opt
    final OtpModel otpModel = OtpModel(
      businessId: businessId,
      amount: _amount,
      refNo: _phoneNo.substring(8),
      shortCode: _businessShortCode,
      mpesaTransId: _mpesaTransId,
      paymentId: _mpesaMessageId.toJson(),
    );
    await otpModel.save();

    // send otp
    final SmsModule smsModule = SmsModule(
      businessId: businessId,
      phoneNo: _phoneNo,
      body: '''
Mpesa transaction $_mpesaTransId accepted for milk worth Ksh.$_amount
Payment reference is: ${otpModel.refNo}. \nOTP is: ${otpModel.otp}
This OTP expires after 30 minutes.
      '''
    );
    // await smsModule.jarvisSendSms();

    await smsModule.save();

    return Response.ok({
      "ResultCode": 0,
      "ResultDesc": "Confirmation Received Successfully"
    });
  }

  


}