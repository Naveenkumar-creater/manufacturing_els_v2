import 'package:prominous/features/data/model/actual_qty_model.dart';
import 'package:prominous/features/data/model/asset_barcode_model.dart';
import 'package:prominous/features/data/model/scannerforworkstation_model.dart';

import '../../../../constant/request_data_model/api_request_model.dart';
import '../../core/api_constant.dart';

abstract class ScanforworkstationDatasource {
  Future<ScannerforworkstationModel> getWorkstationBarcode(int deptid,int pwsId, String token, String pwsbarcode, int orgid);
}

class ScanforworkstationDatasourceImpl extends ScanforworkstationDatasource {

  @override
   Future<ScannerforworkstationModel> getWorkstationBarcode(int deptid,int pwsId, String token, String pwsbarcode, int orgid)async{
    
   ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "scan_for_workstation_v1",deptId: deptid, pwsid:pwsId ,clientAuthToken: token, pwsBarcode: pwsbarcode , orgid: orgid);

     final response = await ApiConstant.scannerApiRequest(requestBody: requestbody);
     


    final result = ScannerforworkstationModel.fromJson(response);

    return result;
  }
}

  