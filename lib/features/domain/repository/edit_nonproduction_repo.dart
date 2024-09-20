import 'package:prominous/features/domain/entity/edit_nonproduction_lis_entity.dart';

abstract class EditNonproductionRepository{
  Future<EditNonProductionListEntity>getEditNonProductionList(String token ,int ipdid);
}