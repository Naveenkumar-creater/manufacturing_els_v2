import 'package:prominous/features/domain/entity/scan_asset_barcode_entity.dart';

abstract class AssetBarcodeRepository{
  
    Future<ScanAssetBarcodeEntity> getAssetBarcode(int pwsid,int assetId, String token);
}