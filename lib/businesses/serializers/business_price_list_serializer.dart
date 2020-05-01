import 'package:maziwa_otp/maziwa_otp.dart';

class BusinessPriceListSerializer extends Serializable{
  List<double> prices;
  double price;
  @override
  Map<String, dynamic> asMap()=>{
    'prices': prices,
    'price': price,
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    price = double.parse((object['price']?? 0).toString());
    final List<double> _lst =[];
    if(object['prices'] != null){
      for(dynamic item in object['prices']){
        _lst.add(double.parse(item.toString()));
      }
      prices = _lst;
    }
  }

  @override
  void read(Map<String, dynamic> object, {Iterable<String> ignore, Iterable<String> reject, Iterable<String> require}) {
    Iterable<String> _reject = reject;
    if(object['price'] != null){
      try{
        double.parse(object['price'].toString());
      }catch (e){
        print(e);
        _reject = ['price'];
      }
    }

    if(object['prices'] != null){
      try {
        final List<double> _lst = object['prices'] as List<double>;
        if(_lst == null){
          _reject = ['prices'];
        }
      } catch (e) {
        _reject = ['price'];
      }
    }

    super.read(object, ignore: ignore, reject: _reject, require: require);
  }
}