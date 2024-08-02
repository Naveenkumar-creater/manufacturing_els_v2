// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:prominous/constant/request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/card_no_model.dart';


abstract class CardNoDatasource {
  Future<CardNoModel> getCardNo(String token,int cardNo);
}

class CardNoDatasourceImpl implements CardNoDatasource {

  @override
  Future<CardNoModel> getCardNo(String token,int cardNo) async {
    ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "scan_card_for_item_v1", clientAuthToken: token, cardNo: cardNo);
    final response = await ApiConstant.scannerApiRequest(requestBody:requestbody);

    final result = CardNoModel.fromJson(response);

    return result;
  }
}
