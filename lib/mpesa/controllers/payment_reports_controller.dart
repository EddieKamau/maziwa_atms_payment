import 'package:maziwa_otp/businesses/models/businesses_models.dart' show BusinessModel;
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mpesa/models/mpesa_models.dart' show MpesaConfirmationModel, where, ObjectId;
import 'package:maziwa_otp/requests/models/requests_models.dart';
import 'package:maziwa_otp/users/modules/user_email_byid.dart';

class PaymentsReportsController extends ResourceController{

  Response response = Response.serverError();
  final MpesaConfirmationModel mpesaConfirmationModel = MpesaConfirmationModel();
  final BusinessModel businessModel = BusinessModel();

  @Operation.get('businessId')
  Future<Response> fetchSmsReports(@Bind.path('businessId') String businessId)async{
    final String _email = await userEmailById(request.authorization.clientID);
    final RequestsModel requestsModel = RequestsModel(
      url: '/business/paymentReports/$businessId',
      account: _email ?? request.authorization.clientID,
      metadata: 'get mpesa cinfirmations',
      requestMethod: RequestMethod.getmethod
    );

    await requestsModel.save();
    // Auth ..................................................
    final String _userId = request.authorization.clientID;
    ObjectId _id;

    try{
      _id = ObjectId.parse(businessId);
    } catch (e){
      _id = ObjectId();
    } 

    final Map<String, dynamic> _businessRes = await businessModel.findOneBy(where.id(_id));

    if(_businessRes['status'] != 0){
      return Response.serverError(body: {'error': "an error occurred"});
    }
    if(_businessRes['body'] == null){
      return Response.badRequest(body: {"body": "Business does not exist"});
    }
    if(_businessRes['body']['ownerId'].toString() != _userId){
      return Response.unauthorized(body: {"body": "You are not authorized for this business"});
    }

    // Auth ..................................................

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
  final BusinessModel businessModel = BusinessModel();

  @Operation.get('businessId')
  Future<Response> fetchSmsReports(@Bind.path('businessId') String businessId)async{
    final RequestsModel requestsModel = RequestsModel(
      url: '/business/totals/$businessId',
      account: request.authorization.clientID,
      metadata: 'get payment totals',
      requestMethod: RequestMethod.getmethod
    );

    await requestsModel.save();
    // Auth ..................................................
    final String _userId = request.authorization.clientID;
    ObjectId _id;

    try{
      _id = ObjectId.parse(businessId);
    } catch (e){
      _id = ObjectId();
    } 

    final Map<String, dynamic> _businessRes = await businessModel.findOneBy(where.id(_id));

    if(_businessRes['status'] != 0){
      return Response.serverError(body: {'error': "an error occurred"});
    }
    if(_businessRes['body'] == null){
      return Response.badRequest(body: {"body": "Business does not exist"});
    }
    if(_businessRes['body']['ownerId'].toString() != _userId){
      return Response.unauthorized(body: {"body": "You are not authorized for this business"});
    }

    // Auth ..................................................

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

