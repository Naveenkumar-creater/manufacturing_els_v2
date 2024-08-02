import 'package:prominous/features/domain/entity/actual_qty_entity.dart';
import 'package:prominous/features/domain/entity/scan_asset_barcode_entity.dart';
import 'package:prominous/features/domain/repository/actual_qty_repo.dart';
import 'package:prominous/features/domain/repository/asset_barcode_repo.dart';

class AssetBarcodeUsecase{

  final AssetBarcodeRepository assetBarcodeRepository;
  AssetBarcodeUsecase(this.assetBarcodeRepository);

  Future<ScanAssetBarcodeEntity>execute(int pwsid,int assetId, String token) async{
return assetBarcodeRepository.getAssetBarcode(pwsid, assetId, token);
  }
}