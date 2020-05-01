import 'dart:io';

import 'package:args/args.dart';
import 'package:maziwa_otp/models/model.dart';
import 'package:maziwa_otp/models/utils/settings.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:password/password.dart';


void main(List<String> arguments)async {
  exitCode = 0; // presume success
  final Db _db = Db(databaseUrl);
  final DbCollection _dbCollection =  _db.collection(baseUserCollection);


  final parser = ArgParser()
    ..addOption('email', abbr: 'u')
    ..addOption('password', abbr: 'p')
    ..addFlag("role", abbr: 'r');

  ArgResults argResults;
  try{
   argResults = parser.parse(arguments);
  } on FormatException catch (e){
    print("Invalid Argument passed!: ${e.message}");
    exit(2);
  }
   catch (e){
    print(e.runtimeType);
    exit(2);
  }
  if(argResults['role'] == true){
    if(argResults['email'] != null){
      final String _email = argResults['email'].toString();
      if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)){
        print("invalid email");
        exit(1);
      }

      // check if user exists
      await _db.open();
      final int _count = await _dbCollection.count(where.eq('email', _email));
      await _db.close();
      if(_count < 1){
        print("user does not exist!");
        exit(1);
      } 
      
      await _db.open();
      try{
        await _dbCollection.findAndModify(
          query: where.eq('email', _email),
          update: modify.set('role', 'admin')
        );
        await _db.close();
        print("Done!!");
        exit(0);

      }catch (e){
        await _db.close();
        print(e);
        print("Failed!!");
        exit(2);
      }


    }else{
      print("Email is required!");
      exit(2);
    }

        
  }


  if(argResults['email'] != null && argResults['password'] != null){
    final String _email = argResults['email'].toString();
    final String _password = argResults['password'].toString();

    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)){
      print("invalid email");
      exit(2);
    }
    if(_password.length < 7){
      print("password is too short!");
      exit(2);
    }
    

    final Map<String, dynamic> _payload = {
      'email': argResults['email'],
      'password': Password.hash(_password != null ? _password : '', PBKDF2()),
      'tempPassword': null,
      'role': 'admin'
    };

    

    await _db.open();
    try{
      final Map<String, dynamic> _res = await _dbCollection.save(_payload);
      await _db.close();
      print("Done!");
      print(_res);
      exit(0);
    } catch (e) {
      await _db.close();
      print("Failed");
      print(e);
      exit(2);
    }
    


  } else{
    print("email and password required!");
    exit(2);
  }
}