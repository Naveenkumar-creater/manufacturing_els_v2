
import 'package:prominous/features/data/datasource/remote/asset_barcode_datasource.dart';
import 'package:prominous/features/data/model/asset_barcode_model.dart';

import 'package:prominous/features/domain/repository/asset_barcode_repo.dart';

class AssetBarcodeRepositoryImpl extends AssetBarcodeRepository{
  final  AssetBarcodeDatasource assetBarcodeDatasource;
  AssetBarcodeRepositoryImpl(this.assetBarcodeDatasource); 

  @override
  Future<ScanAssetBarcodeModel> getAssetBarcode(int pwsid,int assetId, String token) async{
   ScanAssetBarcodeModel result= await assetBarcodeDatasource.getAssetBarcode(pwsid, assetId, token);
    return result;
  }
  
}