import 'package:prominous/features/domain/entity/employee_entity.dart';


abstract class EmployeeRepository{
  Future<EmployeeEntity>getEmployeeList(int processid,int deptid,int psid,String token);
}