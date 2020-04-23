import 'package:aqueduct/aqueduct.dart';
import 'package:maziwa_otp/businesses/models/businesses_models.dart';
import 'package:maziwa_otp/otp/models/otp_models.dart' show OtpModel, where, modify, ObjectId;
import 'package:maziwa_otp/otp/serializers/otp_serializers.dart' show OtpVerifySerializer;

class OtpVerifyController extends ResourceController{
  Response response = Response.serverError();

  @Operation.post()
  Future<Response> verifyOtp(@Bind.body(require: ['refNo', 'otp']) OtpVerifySerializer otpVerifySerializer)async{
    
    final String _userId = request.authorization.clientID;

    final BusinessModel businessModel = BusinessModel();
    final Map<String, dynamic> _businessRes = await businessModel.findBySelector(
      where.eq("ownerId", _userId).fields(['_id'])
    );

    final List<String> _businessIds = [];
    for (dynamic item in _businessRes['body']){
      _businessIds.add(item['_id'].toJson().toString());
    }
    
    final OtpModel otpModel = OtpModel();
    final Map<String, dynamic> _dbRes = await otpModel.findOneBy(
      where.eq('refNo', otpVerifySerializer.refNo).eq('otp', otpVerifySerializer.otp)
    );

    
    if(_dbRes['status'] == 0){
      final _otpObject = _dbRes['body'];
      if(_otpObject != null){
        if(_businessIds.contains(_dbRes['body']['businessId'])){
          // final int validTillDate = int.parse(((_otpObject['vallidTill'] == null ? _otpObject['validTill'] : _otpObject['vallidTill']) ?? 0).toString());
          final int timeStampDate = int.parse((_otpObject['timeStamp']??0).toString());
          // _otpObject['validTillDate'] = DateTime.fromMillisecondsSinceEpoch(validTillDate).toString();
          _otpObject['timeStampDate'] = DateTime.fromMillisecondsSinceEpoch(timeStampDate).toString();
          response = Response.ok(_otpObject);

          
        } else{
          response = Response.unauthorized(body: {"message": "You are not authorized for this business"});
        }

      } else{
        response = Response.badRequest(body: {"message": "Invalid otp!"});
      }
    }


    return response;
  }


}

class OtpSubscribeController extends ResourceController{
  Response response = Response.serverError();

  @Operation.post()
  Future<Response> verifyOtp(@Bind.body(require: ['refNo', 'otp']) OtpVerifySerializer otpVerifySerializer)async{
    
    final String _userId = request.authorization.clientID;

    final BusinessModel businessModel = BusinessModel();
    final Map<String, dynamic> _businessRes = await businessModel.findBySelector(
      where.eq("ownerId", _userId).fields(['_id'])
    );

    final List<String> _businessIds = [];
    for (dynamic item in _businessRes['body']){
      _businessIds.add(item['_id'].toJson().toString());
    }
    
    final OtpModel otpModel = OtpModel();
    final Map<String, dynamic> _dbRes = await otpModel.findOneBy(
      where.eq('refNo', otpVerifySerializer.refNo).eq('otp', otpVerifySerializer.otp)
    );

    
    if(_dbRes['status'] == 0){
      final _otpObject = _dbRes['body'];
      if(_otpObject != null){
        if(_businessIds.contains(_dbRes['body']['businessId'])){
          final ObjectId _id = ObjectId.parse(_otpObject['_id'].toJson().toString());
          final bool _active = _otpObject['active'] == true;
          final int _vallidTill = int.parse(_otpObject['vallidTill'].toString());
          final String _amount = _otpObject['amount'].toString();
          final String _shortCode = _otpObject['shortCode'].toString();

          if(_active){
            if(DateTime.now().millisecondsSinceEpoch < _vallidTill){

              // final Map<String, dynamic> _dbRes = // if status = 1 report error
              await otpModel.findAndModify(
                selector: where.id(_id),
                modifier: modify.set('active', false)
              );

              response = Response.ok({
                "amount": _amount,
                "otp": otpVerifySerializer.otp,
                "businessShortCode": _shortCode
              });

            } else {
              response = Response.badRequest(body: {"message": "Otp already expired!"});
            }

          } else{
            response = Response.badRequest(body: {"message": "Otp already used!"});
          }
        } else{
          response = Response.unauthorized(body: {"message": "You are not authorized for this business"});
        }

      } else{
        response = Response.badRequest(body: {"message": "Invalid credentials!"});
      }
    }


    return response;
  }


}