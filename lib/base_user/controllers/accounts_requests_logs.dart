import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/requests/models/requests_models.dart';

class AccountsRequestsLogs extends ResourceController{
  final RequestsModel requestsModel = RequestsModel();

  @Operation.get()
  Future<Response> fetchAll()async{
    final Map<String, dynamic> _dbRes = await requestsModel.find();

    if(_dbRes['status'] == 0){
      return Response.ok(_dbRes);
    } else{
      return Response.serverError();
    }


  }

}