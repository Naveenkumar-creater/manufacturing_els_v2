import 'package:prominous/features/domain/entity/employee_entity.dart';
import 'package:prominous/features/domain/repository/employee_repository.dart';

class EmployeeUsecase{
  final EmployeeRepository employeeRepository;
  EmployeeUsecase(this.employeeRepository);

  Future<EmployeeEntity>execute(int processid,int deptid,int psid, String token)async{
return  employeeRepository.getEmployeeList(processid,deptid,psid, token);
  }
}