import 'package:maziwa_otp/businesses/models/businesses_models.dart' show BusinessModel, BusinessPriceListModel, where, modify, ObjectId;
import 'package:maziwa_otp/businesses/serializers/businesses_serializers.dart' show BusinessPriceListSerializer;
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/requests/models/requests_models.dart';
import 'package:maziwa_otp/users/modules/user_email_byid.dart';

class BusinessPriceListController extends ResourceController{
  final BusinessPriceListModel businessPriceListModel = BusinessPriceListModel();
  final BusinessModel businessModel = BusinessModel();

  @Operation.get('businessId')
  Future<Response> fetch(@Bind.path('businessId') String businessId)async{
    final String _email = await userEmailById(request.authorization.clientID);
    final RequestsModel requestsModel = RequestsModel(
      url: '/business/priceList/$businessId',
      account: _email ?? request.authorization.clientID,
      metadata: 'get price list',
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

    final Map<String, dynamic> _dbRes = await businessPriceListModel.findBySelector(where.eq('businessId', businessId).fields(['priceList']));

    if(_dbRes['status'] == 0){
      return Response.ok(_dbRes);
    }else{
      return Response.serverError(body: {'error': 'an error occurred!!'});
    }

  }

  @Operation.post('businessId')
  Future<Response> create(@Bind.path('businessId') String businessId, @Bind.body(require: ['prices']) BusinessPriceListSerializer businessPriceListSerializer)async{
    final String _email = await userEmailById(request.authorization.clientID);
    final RequestsModel requestsModel = RequestsModel(
      url: '/business/priceList/$businessId',
      account: _email ?? request.authorization.clientID,
      metadata: businessPriceListSerializer.asMap(),
      requestMethod: RequestMethod.postMethod
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

    final BusinessPriceListModel _businessPriceListModel = BusinessPriceListModel(
      businessId: businessId,
      priceList: businessPriceListSerializer.prices
    );
    final Map<String, dynamic> _dbRes = await businessPriceListModel.update(
      selector: where.eq('businessId', businessId),
      doc: _businessPriceListModel.asMap(),
      upsert: true
    );

    if(_dbRes['status'] == 0){
      return Response.ok({'body': 'prices saved'});
    }else{
      return Response.serverError(body: {'error': 'an error occurred!!'});
    }

  }

  

  @Operation.put('businessId')
  Future<Response> addPrice(@Bind.path('businessId') String businessId, @Bind.body(require: ['price']) BusinessPriceListSerializer businessPriceListSerializer)async{
    final String _email = await userEmailById(request.authorization.clientID);
    final RequestsModel requestsModel = RequestsModel(
      url: '/business/priceList/$businessId',
      account: _email ?? request.authorization.clientID,
      metadata: businessPriceListSerializer.asMap(),
      requestMethod: RequestMethod.putMethod
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

    final Map<String, dynamic> _dbRes = await businessPriceListModel.findAndModify(
      selector: where.eq('businessId', businessId),
      modifier: modify.push('priceList', businessPriceListSerializer.price)
    );

    if(_dbRes['status'] == 0){
      return Response.ok({'body': 'prices added'});
    }else{
      return Response.serverError(body: {'error': 'an error occurred!!'});
    }

  }

  @Operation.delete('businessId')
  Future<Response> removePrice(@Bind.path('businessId') String businessId, @Bind.query('price') String price)async{
    final String _email = await userEmailById(request.authorization.clientID);
    final RequestsModel requestsModel = RequestsModel(
      url: '/business/priceList/$businessId',
      account: _email ?? request.authorization.clientID,
      metadata: 'delete price',
      requestMethod: RequestMethod.deleteMethod
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

    final Map<String, dynamic> _dbRes = await businessPriceListModel.findAndModify(
      selector: where.eq('businessId', businessId),
      modifier: modify.pull('priceList', double.parse(price.toString()))
    );

    if(_dbRes['status'] == 0){
      return Response.ok({'body': 'prices deleted'});
    }else{
      return Response.serverError(body: {'error': 'an error occurred!!'});
    }

  }

    


}