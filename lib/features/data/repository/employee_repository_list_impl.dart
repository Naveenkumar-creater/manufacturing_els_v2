import 'package:prominous/features/data/model/employee_model.dart';
import '../../domain/repository/employee_repository.dart';
import '../datasource/remote/employee_datasource.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeDatasource employeeDatasource;

  EmployeeRepositoryImpl(this.employeeDatasource);

  @override
  Future<EmployeeModel> getEmployeeList(int processid,int deptid,int psid, String token) async {
    final result = employeeDatasource.getEmployeeList(processid,deptid,psid,token);
    return result;
  }
}
