
import 'package:prominous/features/domain/entity/scannerforworkstation_entity.dart';

import 'package:prominous/features/domain/repository/scannerforworkstation_repo.dart';

class ScanforworkstationUsecase {
  final ScannerforworkstationRepository scannerforworkstationRepo;
  

  ScanforworkstationUsecase(this.scannerforworkstationRepo);

Future<ScannerforworkstationEntity> execute (int deptid,int pwsId, String token, String pwsbarcode){
 return scannerforworkstationRepo.getWorkstationBarcode(deptid, pwsId, token, pwsbarcode)
;
}
}