import 'package:prominous/features/domain/entity/process_entity.dart';
import 'package:prominous/features/domain/repository/process_repository.dart';

import '../entity/emp_details_entity.dart';
import '../repository/emp_details_repository.dart';

class EmpDetailsUsecase {
  final EmpDetailsRepository empDetailsRepository;
  EmpDetailsUsecase(this.empDetailsRepository);

  Future<EmpDetailsEntity> execute(String token) async {
    return empDetailsRepository.getEmpDetails(token);
  }
}
