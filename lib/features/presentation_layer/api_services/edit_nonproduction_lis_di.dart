import 'package:flutter/cupertino.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/edit_nonproduction_lis_datasource.dart';
import 'package:prominous/features/data/repository/edit_nonproduction_repo_impl.dart';
import 'package:prominous/features/domain/entity/edit_nonproduction_lis_entity.dart';
import 'package:prominous/features/domain/usecase/edit_nonproduction_lis_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/edit_nonproduction_provider.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditNonProductionListService {
  Future<void> getNonProductionList({
    required BuildContext context,
    required int ipdid,

  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

      final editNonproductionusecase = EditNonproductionListUsecase(
        EditNonproductionRepoImpl(
          EditNonproductionListDatasourceImpl(),
        ),
      );

int? orgid=Provider.of<LoginProvider>(context, listen: false).user?.userLoginEntity?.orgId  ?? 0;
      EditNonProductionListEntity user = await editNonproductionusecase.execute(token,ipdid, orgid);

      // Update the provider with the fetched data
      Provider.of<EditNonproductionProvider>(context, listen: false).setNonProduction(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}