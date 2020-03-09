import 'package:aqueduct/aqueduct.dart';
import 'package:maziwa_otp/businesses/models/businesses_models.dart' show BusinessModel, where, ObjectId;
import 'package:maziwa_otp/businesses/serializers/businesses_serializers.dart' show BusinessCreateSerializer;
import 'package:maziwa_otp/mpesa/modules/mpesa_modules.dart' show mpesaRegisterUrlModule;

class BusinessCreateController extends ResourceController{

  Response response = Response.serverError();


  @Operation.post()
  Future<Response> createBusiness(
    @Bind.body(require: ['label', 'shortCode', 'consumerKey', 'consumerSecret'])
    BusinessCreateSerializer businessCreateSerializer
    )async{
    
      final BusinessModel businessModel = BusinessModel(
        ownerId: request.authorization.clientID,
        label: businessCreateSerializer.label,
        shortCode: businessCreateSerializer.shortCode,
        consumerKey: businessCreateSerializer.consumerKey,
        consumerSecret: businessCreateSerializer.consumerSecret,
      );

      final Map<String, dynamic> _dbRes = await businessModel.save();

      if(_dbRes['status'] == 0){
        response = Response.ok(businessModel.asMap());

        // register url
        // final _res = 
        await mpesaRegisterUrlModule(
          shortCode: businessCreateSerializer.shortCode,
          businessId: businessModel.id,
          consumerKey: businessCreateSerializer.consumerKey,
          consumerSecret: businessCreateSerializer.consumerSecret
        );


      }

      return response;
  }

  @Operation.get()
  Future<Response> fetchBusinesses()async{

    final String _userId = request.authorization.clientID;
    final BusinessModel businessModel = BusinessModel();

    final Map<String, dynamic> _dbRes = await businessModel.findBySelector(
      where.eq('ownerId', _userId)
    );

    if(_dbRes['status'] == 0){
      response = Response.ok(_dbRes['body']);
    }


    return response;

  }
  
  @Operation.delete('businessId')
  Future<Response> deleteBusiness(@Bind.path('businessId') String businessId)async{

    ObjectId _id;
    try{
      _id = ObjectId.parse(businessId);
    } catch (e){
      _id = ObjectId();
    }

    final String _userId = request.authorization.clientID;
    final BusinessModel businessModel = BusinessModel();

    final Map<String, dynamic> _dbRes = await businessModel.remove(where.id(_id).eq('ownerId', _userId));

    if(_dbRes['status'] == 0){
      if(_dbRes['body']['n'] == 0){
        response = Response.badRequest(body: {"message": "Business does not exist"});
      } else{
        response = Response.accepted();
        
      }
    }


    return response;

  }

}