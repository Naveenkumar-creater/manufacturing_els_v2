import 'package:prominous/features/data/model/actual_qty_model.dart';
import 'package:prominous/features/data/model/asset_barcode_model.dart';

import '../../../../constant/request_model.dart';
import '../../core/api_constant.dart';

abstract class AssetBarcodeDatasource {
  Future<ScanAssetBarcodeModel> getAssetBarcode(int pwsid,int assetId, String token);
}

class AssetBarcodeDatasourceImpl extends AssetBarcodeDatasource {
  // final AllocationClient allocationClient;

  // ActivityDatasourceImpl(this.allocationClient);
  
  
  @override
  Future<ScanAssetBarcodeModel> getAssetBarcode(int pwsid,int assetId, String token) async{

    
   ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "scan_asset_id_v1",pwsspwsid: pwsid, assetid:assetId ,clientAuthToken: token );
     final response = await ApiConstant.scannerApiRequest(requestBody: requestbody);
     
    final result = ScanAssetBarcodeModel.fromJson(response);
      print(result);
      return result;
  }
}

  