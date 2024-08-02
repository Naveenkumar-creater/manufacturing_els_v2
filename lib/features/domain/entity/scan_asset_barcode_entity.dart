import 'package:equatable/equatable.dart';
import 'package:prominous/features/data/model/asset_barcode_model.dart';

class ScanAssetBarcodeEntity extends Equatable{
final ScanAseetBarcode? scanAseetBarcode;
ScanAssetBarcodeEntity( {this.scanAseetBarcode});

  @override
  // TODO: implement props
  List<Object?> get props => [scanAseetBarcode];
  
}

class ScanAseetBarcode extends Equatable{

    ScanAseetBarcode({
    required this.pwsaId,
        required this.pwsaAssetId,
        required this.pwsaPwssId,
    });

 final int? pwsaId;
    final int? pwsaAssetId;
    final int? pwsaPwssId;
  @override
  // TODO: implement props
  List<Object?> get props => [pwsaId,pwsaAssetId,pwsaPwssId];
  
}