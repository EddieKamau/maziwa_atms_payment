import 'package:maziwa_otp/businesses/models/businesses_models.dart' show BusinessPriceListModel, where;

Future<List<double>> getPriceListbyBusinessId(String businessId)async{
  final BusinessPriceListModel businessPriceListModel = BusinessPriceListModel();
  final Map<String, dynamic> _dbRes = await businessPriceListModel.findOneBy(
    where.eq('businessId', businessId)
  );

  if(_dbRes['status'] == 0){
    if(_dbRes['body'] != null){
      final List<double> _lst = [];
      for(dynamic item in _dbRes['body']['priceList']){
        _lst.add(double.parse(item.toString()));
      }
      return _lst.isEmpty ? null : _lst;

    } else {
      return null;
    }

  }else{
    return null;
  }
}