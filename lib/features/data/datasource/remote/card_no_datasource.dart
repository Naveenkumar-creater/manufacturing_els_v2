// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/card_no_model.dart';


abstract class CardNoDatasource {
  Future<CardNoModel> getCardNo(String token,int cardNo,int orgid);
}

class CardNoDatasourceImpl implements CardNoDatasource {

  @override
  Future<CardNoModel> getCardNo(String token,int cardNo, int orgid) async {
    // ApiRequestDataModel requestbody = ApiRequestDataModel(
    //       apiFor: "scan_card_for_item_v1", clientAuthToken: token, cardNo: cardNo);
   final request={
   "client_aut_token": token,
    "api_for": "scan_card_for_item_v1",
     "card_no":cardNo,
     "org_id":orgid
    
};
    final response = await ApiConstant.scannerApiRequest(requestBody:request);

    final result = CardNoModel.fromJson(response);

    return result;
  }
}
