import 'package:prominous/features/domain/entity/process_entity.dart';
import 'package:prominous/features/domain/repository/process_repository.dart';

class ProcessUsecase {
  final ProcessRepository processRepository;
  ProcessUsecase(this.processRepository);

  Future<ProcessEntity> execute(
    String token,
    int deptid
  ) async {
    return processRepository.getProcessList(token,deptid);
  }
}
