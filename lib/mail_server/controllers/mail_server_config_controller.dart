import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mail_server/models/mail_server_models.dart';
import 'package:maziwa_otp/mail_server/serializers/mail_server_serializers.dart' show MailServerConfSerializer;

class MailServerConfigController extends ResourceController{
  @Operation.post()
  Future<Response> create(
    @Bind.body(require: [
      'name', 
      'username', 
      'password',
      'port',
      'host',
    ]) MailServerConfSerializer mailServerConfSerializer
  )async{

    final MailServerModel mailServerModel = MailServerModel(
      mailHostConf: mailServerConfSerializer.host,
      mailPortConf: mailServerConfSerializer.port,
      mailNametConf: mailServerConfSerializer.name,
      mailUsernametConf: mailServerConfSerializer.username,
      mailPasswordConf: mailServerConfSerializer.password,
      mailActivateAccountMessageConf: mailServerConfSerializer.activateAccountBody,
      mailActivateAccountSubjectConf: mailServerConfSerializer.activateAccountSubject,
      mailCreatAccountMessageConf: mailServerConfSerializer.creatAccountBody,
      mailCreatAccountSubjectConf: mailServerConfSerializer.creatAccountSubject,
      mailResetAccountMessageConf: mailServerConfSerializer.resetAccountBody,
      mailResetAccountSubjectConf: mailServerConfSerializer.resetAccountSubject,
    );

    await mailServerModel.update(doc: mailServerModel.document, upsert: true);

    final Map<String, dynamic> _dbRes = await mailServerModel.update(doc: mailServerModel.document, upsert: true);
    if(_dbRes['status'] == 0){

      return Response.accepted();

    }else {
      return Response.serverError();
    }

  }

  @Operation.get()
  Future<Response> getMailConf()async{
    final MailServerModel mailServerModel = MailServerModel();
    final Map<String, dynamic> _dbRes = await mailServerModel.findOneBy(null);
    if(_dbRes['status'] == 0){

      return Response.ok(_dbRes['body']);

    }else {
      return Response.serverError();
    }

  }
}