import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/actual_qty_entity.dart';
import 'package:prominous/features/domain/entity/scan_asset_barcode_entity.dart';

class AssetBarcodeProvider extends ChangeNotifier {
  ScanAssetBarcodeEntity? _user;
  ScanAssetBarcodeEntity? get user => _user;
  void setUser(ScanAssetBarcodeEntity actual) {
    _user = actual;
    notifyListeners();
  }
}
