import 'package:prominous/features/data/datasource/remote/edit_nonproduction_lis_datasource.dart';
import 'package:prominous/features/data/model/edit_non_production_lis_model.dart';

import 'package:prominous/features/domain/repository/edit_nonproduction_repo.dart';


class EditNonproductionRepoImpl extends EditNonproductionRepository {
 final EditNonproductionListDatasourceImpl editNonproductionListDatasourceImpl;
 EditNonproductionRepoImpl(this.editNonproductionListDatasourceImpl);

  @override
  Future<EditNonProductionLisModel> getEditNonProductionList(String token, int ipdid)async {
   return editNonproductionListDatasourceImpl.getEditNonProductionList(token, ipdid);
  }
  
}