import 'package:prominous/features/domain/entity/process_entity.dart';

import '../entity/emp_details_entity.dart';

abstract class EmpDetailsRepository {
  Future<EmpDetailsEntity> getEmpDetails(String token);
}
