import 'package:prominous/features/data/datasource/remote/listofrootcause_datasource.dart';
import 'package:prominous/features/domain/entity/listof_rootcause_entity.dart';
import 'package:prominous/features/domain/repository/listofrootcause_repo.dart';

class ListofRootcauseRepoImpl extends ListofRootCauseRepository{
  final ListofRootCauseDatasourceImpl listofRootCauseDatasourceImpl;

ListofRootcauseRepoImpl(this.listofRootCauseDatasourceImpl);
  @override
  Future<ListOfRootCauseEntity> getListofRootcause(String token, int deptid, int incidentid, int orgid) {
    return listofRootCauseDatasourceImpl.getListofRootcause(token, deptid, incidentid,  orgid);
  }
}