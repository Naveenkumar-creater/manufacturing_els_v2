import 'package:equatable/equatable.dart';

class ScannerforworkstationEntity extends Equatable {
    ScannerforworkstationEntity({
        required this.workStationScanEntity,
    });

    final WorkStationScanEntity? workStationScanEntity;
    
      @override
      // TODO: implement props
      List<Object?> get props => throw UnimplementedError();


}

class WorkStationScanEntity extends Equatable {
    WorkStationScanEntity({
        required this.pwsBarcode,
        required this.pwsName,
        required this.pwsId,
    });

    final String? pwsBarcode;
    final String? pwsName;
    final int? pwsId;
    
      @override
      // TODO: implement props
      List<Object?> get props => [pwsBarcode,pwsName,pwsId];

  

}
