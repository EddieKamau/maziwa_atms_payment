import 'package:maziwa_otp/maziwa_otp.dart';

Future main() async {
  final app = Application<MaziwaOtpChannel>()
      ..options.configurationFilePath = "config.yaml"
      ..options.port = 8888;

  // final count = Platform.numberOfProcessors ~/ 2;
  const int count = 1;
  await app.start(numberOfInstances: count > 0 ? count : 1);

  // // init ensure indexes
  // final Model model = Model(dbUrl: databaseUrl);
  // await model.indexes();
  

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}