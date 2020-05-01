import 'package:maziwa_otp/models/model.dart';

class BusinessPriceListModel extends Model{
  BusinessPriceListModel({
    this.businessId, this.priceList
  }):super(dbUrl: databaseUrl, collectionName: businessPriceListsCollection){
    priceList ??= [];
  }

  List<double> priceList;
  String businessId;

  Map<String, dynamic> asMap()=>{
    'businessId': businessId,
    'priceList': priceList,
  };
}