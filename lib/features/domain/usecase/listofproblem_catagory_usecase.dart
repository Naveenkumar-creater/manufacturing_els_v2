


import 'package:prominous/features/domain/entity/listofproblem_catagory_entity.dart';
import 'package:prominous/features/domain/repository/listofproblem_catagory_repo.dart';

class ListofproblemCategoryUsecase  {
  final ListofproblemCategoryRepository listofproblemCategoryRepository;
  ListofproblemCategoryUsecase( this.listofproblemCategoryRepository);

  Future<ListOfProblemCategoryEntity> execute (String token, int deptid, int incidentId) {

   return  listofproblemCategoryRepository.getListofProblemCategory(token, deptid, incidentId);
  }
  
} 