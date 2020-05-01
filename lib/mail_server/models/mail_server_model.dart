import 'package:maziwa_otp/models/model.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class MailServerModel extends Model{
  MailServerModel({
    this.mailHostConf, 
    this.mailPortConf, 
    this.mailNametConf, 
    this.mailUsernametConf, 
    this.mailPasswordConf, 
    this.mailCreatAccountSubjectConf, 
    this.mailCreatAccountMessageConf, 
    this.mailResetAccountSubjectConf, 
    this.mailResetAccountMessageConf, 
    this.mailActivateAccountSubjectConf, 
    this.mailActivateAccountMessageConf,
    }):super(dbUrl: databaseUrl, collectionName: mailServersCollection){
    super.document = asMap();
  }

  final String mailHostConf;
  final int mailPortConf;
  final String mailUsernametConf;
  final String mailNametConf;
  final String mailPasswordConf;
  final String mailCreatAccountSubjectConf;
  final String mailCreatAccountMessageConf;
  final String mailResetAccountSubjectConf;
  final String mailResetAccountMessageConf;
  final String mailActivateAccountSubjectConf;
  final String mailActivateAccountMessageConf;

  Map<String, dynamic> asMap()=>{
    'mailHostConf': mailHostConf, 
    'mailPortConf': mailPortConf, 
    'mailNametConf': mailNametConf, 
    'mailUsernametConf': mailUsernametConf, 
    'mailPasswordConf': mailPasswordConf, 
    'mailCreatAccountSubjectConf': mailCreatAccountSubjectConf, 
    'mailCreatAccountMessageConf': mailCreatAccountMessageConf, 
    'mailResetAccountSubjectConf': mailResetAccountSubjectConf, 
    'mailResetAccountMessageConf': mailResetAccountMessageConf, 
    'mailActivateAccountSubjectConf': mailActivateAccountSubjectConf, 
    'mailActivateAccountMessageConf': mailActivateAccountMessageConf,
  };

  Future<bool> sendMail(MailType mailType, String _message, String _email)async{
    String _body = '';
    String _subject = '';
    String _host = '';
    String _username = '';
    String _name = '';
    String _password = '';
    int _port = 0;
    // get conf
    final Map<String, dynamic> _dbRes = await findOneBy(null);
    if(_dbRes['status'] == 0){
      // get body and subject
      if(_dbRes != null){
        _host = _dbRes['body']['mailHostConf'].toString();
        _name = _dbRes['body']['mailNametConf'].toString();
        _username = _dbRes['body']['mailUsernametConf'].toString();
        _password = _dbRes['body']['mailPasswordConf'].toString();
        try {
          _port = int.parse(_dbRes['body']['mailPortConf'].toString());
        } catch (e) {
          _port = null;
        }
        switch (mailType) {
          case MailType.accountActivate:
            _body = _dbRes['body']['mailActivateAccountMessageConf']?.toString()?? _body;
            _subject = _dbRes['body']['mailActivateAccountSubjectConf']?.toString()?? _subject;
            break;
          case MailType.accountCreate:
            _body = _dbRes['body']['mailCreatAccountMessageConf']?.toString()?? _body;
            _subject = _dbRes['body']['mailCreatAccountMessageConf']?.toString()?? _subject;
            break;
          case MailType.accountReset:
            _body = _dbRes['body']['mailResetAccountMessageConf']?.toString()?? _body;
            _subject = _dbRes['body']['mailResetAccountMessageConf']?.toString()?? _subject;
            break;
          
          default:
        }

        // send mail
        final SmtpServer smtpServer = SmtpServer(
          _host,
          port: _port,
          username: _username,
          password: _password
        );

        final Message message = Message()
              ..from = Address(_username, _name)
              ..recipients.add(_email)
              ..subject = _subject
              ..text = "$_body \n$_message";

        try {
          await send(message, smtpServer);
          return true;
        } catch (e) {
          return false;
        }

      }else{
        return false;
      }

    }else{
      return false;
    }
  }
  

}

enum MailType{
  accountCreate,
  accountActivate,
  accountReset,
}