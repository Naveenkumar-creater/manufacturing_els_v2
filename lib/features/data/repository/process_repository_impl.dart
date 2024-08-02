// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:prominous/features/data/datasource/remote/process_datasource.dart';
import 'package:prominous/features/domain/repository/process_repository.dart';
import '../../domain/entity/process_entity.dart';

class ProcessRepositoryImpl implements ProcessRepository {
  final ProcessDatasource processDatasource;
  ProcessRepositoryImpl(
    this.processDatasource,
  );
  @override
  Future<ProcessEntity> getProcessList(
    String token,
    int deptid
  ) async {
    final result = await processDatasource.getProcessList(token,deptid);
    return result;
  }
}
