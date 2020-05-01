import 'dart:convert';

import 'package:aqueduct/aqueduct.dart';
import 'package:maziwa_otp/businesses/models/businesses_models.dart' show BusinessModel, where, ObjectId;
import 'package:maziwa_otp/businesses/serializers/businesses_serializers.dart' show BusinessSimulatePaymentSerializer;
import 'package:maziwa_otp/mpesa/modules/mpesa_modules.dart' show mpesaSimulateModule;
import 'package:maziwa_otp/requests/models/requests_models.dart';
import 'package:maziwa_otp/users/modules/user_email_byid.dart';

class BusinessSimulatePaymentController extends ResourceController{
  
  Response response = Response.serverError();


  @Operation.post('businessId')
  Future<Response> simulatePayment(
    @Bind.body(require: ['amount', 'refNo']) BusinessSimulatePaymentSerializer businessSimulatePaymentSerializer,
    @Bind.path('businessId') String businessId
    )async{
      final String _email = await userEmailById(request.authorization.clientID);
      final RequestsModel requestsModel = RequestsModel(
      url: '/business/simulate/$businessId',
      account: _email ?? request.authorization.clientID,
      metadata: businessSimulatePaymentSerializer.asMap(),
      requestMethod: RequestMethod.postMethod
    );

    await requestsModel.save();

      final String _userId = request.authorization.clientID;
      ObjectId _id;

      try{
        _id = ObjectId.parse(businessId);
      } catch (e){
        _id = ObjectId();
      }

      final BusinessModel businessModel = BusinessModel();
      final Map<String, dynamic> _dbRes = await businessModel.findOneBy(where.id(_id));
      if(_dbRes['status'] == 0){
        if(_dbRes['body'] != null){
          final String ownerId = _dbRes['body']['ownerId'].toString();

          if(ownerId == _userId){
            final String shortCode = _dbRes['body']['shortCode'].toString();
            final String consumerKey = _dbRes['body']['consumerKey'].toString();
            final String consumerSecret = _dbRes['body']['consumerSecret'].toString();
            final String amount = businessSimulatePaymentSerializer.amount;
            final String refNo = businessSimulatePaymentSerializer.refNo;
            const String phoneNo = '254708374149';

            final _res = await mpesaSimulateModule(
              shortCode: shortCode,
              amount: amount,
              phoneNo: phoneNo,
              refNo: refNo,
              consumerKey: consumerKey,
              consumerSecret: consumerSecret
            );

            if(_res != null){
              response = Response.ok(json.decode(_res.body));
            } else{
              response = Response.serverError();
            }

            

          } else{
            response = Response.unauthorized(body: {"message": "You are not authorized for this business"});
          }

        } else{
          response = Response.badRequest(body: {"message": "Business does not exist"});
        }
      }

    return response;
  }
}