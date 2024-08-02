import 'package:prominous/features/data/datasource/remote/target_qty_datasource.dart';
import 'package:prominous/features/data/model/target_qty_model.dart';
import 'package:prominous/features/domain/entity/target_qty_entity.dart';
import 'package:prominous/features/domain/repository/target_qty_repo.dart';

class TargetQtyRepoImpl implements TargetQtyRepository {
  TargetQtyDatasourceImpl targetQtyDatasource = TargetQtyDatasourceImpl();

  TargetQtyRepoImpl(TargetQtyDatasourceImpl targetQtyDatasourceImpl);
  @override
  Future<TargetQtyModel> getTargetQty ( int paid,int deptid,int psid,int pwsid, String token) async {
    TargetQtyModel result =
        await targetQtyDatasource.getTargetQty(paid, deptid, psid, pwsid, token);
    return result;
  }
}
