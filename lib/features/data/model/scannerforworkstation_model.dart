import 'package:prominous/features/domain/entity/scannerforworkstation_entity.dart';

class ScannerforworkstationModel extends ScannerforworkstationEntity{
    ScannerforworkstationModel({
        required this.workStationScan,
    }):super(workStationScanEntity: workStationScan);

    final WorkStationScan? workStationScan;

    factory ScannerforworkstationModel.fromJson(Map<String, dynamic> json){ 
        return ScannerforworkstationModel(
            workStationScan: json["response_data"]["WorkStationScan"] == null ? null : WorkStationScan.fromJson(json["response_data"]["WorkStationScan"]),
        );
    }

}

class WorkStationScan extends WorkStationScanEntity{
    WorkStationScan({
        required this.pwsBarcode,
        required this.pwsName,
        required this.pwsId,
    }):super(pwsBarcode: pwsBarcode,pwsId: pwsId,pwsName: pwsName);

    final String? pwsBarcode;
    final String? pwsName;
    final int? pwsId;

    factory WorkStationScan.fromJson(Map<String, dynamic> json){ 
        return WorkStationScan(
            pwsBarcode: json["pws_barcode"],
            pwsName: json["pws_name"],
            pwsId: json["pws_id"],
        );
    }

}
