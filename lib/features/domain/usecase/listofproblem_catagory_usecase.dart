import 'package:prominous/features/domain/entity/listofproblem_catagory_entity.dart';
import 'package:prominous/features/domain/repository/listofproblem_catagory_repo.dart';


class ListofproblemCatagoryUsecase  {
  final ListofproblemCatagoryRepository listofproblemCatagoryRepository;
  ListofproblemCatagoryUsecase( this.listofproblemCatagoryRepository);

  Future<ListOfProblemCatagoryEntity> execute (String token, int deptid, int incidentId) {

   return  listofproblemCatagoryRepository.getListofProblemCatagory(token, deptid, incidentId);
  }
  
} 