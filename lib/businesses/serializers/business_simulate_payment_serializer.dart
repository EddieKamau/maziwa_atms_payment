import 'package:maziwa_otp/maziwa_otp.dart';

class BusinessSimulatePaymentSerializer extends Serializable{
  String amount;
  String refNo;
  @override
  Map<String, dynamic> asMap() => {
    "amount": amount,
    "refNo": refNo,
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    amount = object['amount'].toString();
    refNo = object['refNo'].toString();
  }

  @override
  void read(Map<String, dynamic> object, {Iterable<String> ignore, Iterable<String> reject, Iterable<String> require}) {
    final String _amount = object['amount'].toString();
    Iterable<String> _reject = reject;
    try {
      double.parse(_amount);
    } catch (e) {
      _reject = ['amount'];
    }
    super.read(object, ignore: ignore, reject: _reject, require: require);
  }
}