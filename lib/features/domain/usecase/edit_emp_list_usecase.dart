import 'package:prominous/features/domain/entity/edit_emp_list_entity.dart';
import 'package:prominous/features/domain/entity/listofempworkstation_entity.dart';
import 'package:prominous/features/domain/repository/edit_emp_list_repo.dart';
import 'package:prominous/features/domain/repository/listofempworkstation_repo.dart';

class EditListofEmpworkstationUsecase {
  final EditListofEmpWorkstationRepository editListofEmpWorkstationRepository;
  

  EditListofEmpworkstationUsecase(this.editListofEmpWorkstationRepository);

Future<EditListofEmpWorkstationEntity> execute (int ipdid,String token){
  return editListofEmpWorkstationRepository.getEditListofEmpWorkstation( ipdid,token);

;}
}