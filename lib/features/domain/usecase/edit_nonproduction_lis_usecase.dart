import 'package:prominous/features/domain/entity/edit_nonproduction_lis_entity.dart';
import 'package:prominous/features/domain/repository/edit_nonproduction_repo.dart';

class EditNonproductionListUsecase{
final EditNonproductionRepository editNonproductionRepository;
EditNonproductionListUsecase(this.editNonproductionRepository);

Future<EditNonProductionListEntity> execute(String token, int ipdid, int orgid)async{

return editNonproductionRepository.getEditNonProductionList(token, ipdid,  orgid);
  
}

}