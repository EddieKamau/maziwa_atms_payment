import 'package:maziwa_otp/models/model.dart' show Model, databaseUrl;
import 'package:maziwa_otp/routes/routes_export.dart';

import 'maziwa_otp.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class MaziwaOtpChannel extends ApplicationChannel {
  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    // init ensure indexes
    final Model model = Model(dbUrl: databaseUrl);
    await model.indexes();
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://aqueduct.io/docs/http/request_controller/
    router
      .route("/example")
      .linkFunction((request) async {
        return Response.ok({"key": "value"});
      });

    // base user
    baseUserRoute(router);
    
    // businesses
    businessRoutes(router);


    // mpesa
    mpesaRoutes(router);
    

    // otp
    otpRoutes(router);

    // users
    usersRoutes(router);

    return router;
  }
}