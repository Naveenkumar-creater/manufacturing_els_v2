

import 'package:prominous/features/domain/entity/scan_asset_barcode_entity.dart';

class ScanAssetBarcodeModel extends ScanAssetBarcodeEntity {
    ScanAssetBarcodeModel({
        required this.scanAssetId,
    }):super(scanAseetBarcode:scanAssetId );

    final ScanAssetId? scanAssetId;

    factory ScanAssetBarcodeModel.fromJson(Map<String, dynamic> json){ 
        return ScanAssetBarcodeModel(
            scanAssetId: json["response_data"]["Scan_Asset_Id"] == null ? null : ScanAssetId.fromJson(json["response_data"]["Scan_Asset_Id"]),
        );
    }

 

}



class ScanAssetId extends ScanAseetBarcode{
    ScanAssetId({
         required this.pwsaId,
        required this.pwsaAssetId,
        required this.pwsaPwssId,
    }) : super(pwsaAssetId:pwsaAssetId, pwsaId: pwsaId,pwsaPwssId: pwsaPwssId );

    


    final int? pwsaId;
    final int? pwsaAssetId;
    final int? pwsaPwssId;

    factory ScanAssetId.fromJson(Map<String, dynamic> json){ 
        return ScanAssetId(
        pwsaId: json["pwsa_id"],
            pwsaAssetId: json["pwsa_asset_id"],
            pwsaPwssId: json["pwsa_pwss_id"],
        );
    }




}
