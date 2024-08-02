import 'package:prominous/features/domain/entity/process_entity.dart';

abstract class ProcessRepository {
  Future<ProcessEntity> getProcessList(String token,int deptid);
}
