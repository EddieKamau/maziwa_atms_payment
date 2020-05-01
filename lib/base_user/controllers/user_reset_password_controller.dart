import 'package:maziwa_otp/base_user/models/base_user_models.dart';
import 'package:maziwa_otp/base_user/serializers/base_user_serializers.dart';
import 'package:maziwa_otp/maziwa_otp.dart';
import 'package:maziwa_otp/mail_server/models/mail_server_models.dart';
import 'package:password/password.dart';
import 'package:random_string/random_string.dart';

class BaseUserResetPasswordController extends ResourceController{
  final  BaseUserModel userModel = BaseUserModel();
  final String _password = randomAlphaNumeric(10);
  @Operation.get()
  Future<Response> resetPassord(@Bind.query('email') String email)async{

    // check if exists
    if(await userModel.exists(where.eq("email", email))){
      final Map<String, dynamic> _dbRes = await userModel.findAndModify(
        selector: where.eq('email', email),
        modifier: modify.set('tempPassword', Password.hash(_password != null ? _password : '', PBKDF2()))
      );

      if(_dbRes['status'] == 0){
        // send mail
        final MailServerModel mailServerModel = MailServerModel();
        final bool _sent = await mailServerModel.sendMail(
          MailType.accountReset, 
          "Use the password below to Reset your password! \nPassword: $_password", 
          email
        );
        if(_sent){
          return Response.accepted();
        }else{
          return Response.badRequest(body: "unable to send mail");
        }
        

      }else{
        return Response.serverError();
      }

    } else{
      return Response.badRequest(body: {
        "error": "Invalid email"
      });
    }

  }

  


}

class BaseUserChangePasswordController extends ResourceController{

  final  BaseUserModel userModel = BaseUserModel();

  @Operation.put()
  Future<Response> changePassword(@Bind.body(require: ['password']) UsersSerializer usersSerializer)async{
    final String _userId = request.authorization?.clientID;
    final Map<String, dynamic> _dbRes = await userModel.findAndModify(
      selector: where.id(ObjectId.parse(_userId)),
      modifier: modify
                .set('password', Password.hash(usersSerializer.password != null ? usersSerializer.password : '', PBKDF2()))
                .set('tempPassword', null)
    );
    if(_dbRes['status'] == 0){
      return Response.accepted();
    }else{
      return Response.serverError();
    }

  }

}