import 'package:maziwa_otp/businesses/models/businesses_models.dart' show BusinessModel;
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mpesa/models/mpesa_models.dart' show MpesaValidationModel, where, ObjectId;
import 'package:maziwa_otp/requests/models/requests_models.dart';
import 'package:maziwa_otp/users/modules/user_email_byid.dart';

class PaymentsValidationsReportsController extends ResourceController{

  Response response = Response.serverError();
  final MpesaValidationModel mpesaValidationModel = MpesaValidationModel();
  final BusinessModel businessModel = BusinessModel();

  @Operation.get('businessId')
  Future<Response> fetchMpesaValidationReports(@Bind.path('businessId') String businessId, {@Bind.query('filter') String filter})async{
    final String _email = await userEmailById(request.authorization.clientID);
    final RequestsModel requestsModel = RequestsModel(
      url: '/business/paymentValidationsReports/$businessId',
      account: _email ?? request.authorization.clientID,
      metadata: 'fetch mpesa validations',
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

