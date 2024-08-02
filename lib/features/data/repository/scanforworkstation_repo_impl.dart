import 'package:prominous/features/data/datasource/remote/listofempworkstation_datasource.dart';
import 'package:prominous/features/data/datasource/remote/scanforworkstation_datasource.dart';
import 'package:prominous/features/data/model/listofempworkstation_model.dart';
import 'package:prominous/features/data/model/scannerforworkstation_model.dart';
import 'package:prominous/features/domain/repository/scannerforworkstation_repo.dart';


class ScanforworkstationRepoImpl extends ScannerforworkstationRepository{
ScanforworkstationDatasource scanforworkstationDatasource;

  ScanforworkstationRepoImpl( this.scanforworkstationDatasource);
  @override
     Future<ScannerforworkstationModel> getWorkstationBarcode(int deptid,int pwsId, String token, String pwsbarcode) async{
  return  await scanforworkstationDatasource.getWorkstationBarcode(deptid, pwsId, token, pwsbarcode);
  }
  
}