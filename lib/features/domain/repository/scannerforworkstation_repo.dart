import 'package:prominous/features/domain/entity/scan_asset_barcode_entity.dart';
import 'package:prominous/features/domain/entity/scannerforworkstation_entity.dart';

abstract class ScannerforworkstationRepository{
  
    Future<ScannerforworkstationEntity> getWorkstationBarcode(int deptid,int pwsId, String token, String pwsbarcode);
}