import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/features/data/datasource/remote/card_no_datasource.dart';
import 'package:prominous/features/data/repository/card_no_repo_impl.dart';
import 'package:prominous/features/domain/entity/card_no_entity.dart';
import 'package:prominous/features/domain/repository/card_no_repo.dart';
import 'package:prominous/features/domain/usecase/card_no_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/card_no_provider.dart';

import '../../../constant/show_pop_error.dart';


class CardNoApiService {
  Future<void> getCardNo({
    required BuildContext context,
    required int cardNo
    //required emp_mgr,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";
    
      CardNoDatasource cardNoDatasource = CardNoDatasourceImpl();
      CardNoRepository allocationRepository = CardNoRepositoryImpl(cardNoDatasource);
      CardNoUsecase cardNousecase = CardNoUsecase(allocationRepository);

      CardNoEntity user = await cardNousecase.execute(token,cardNo);

      Provider.of<CardNoProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
      rethrow;
    }
  }
}
