import 'package:prominous/features/domain/entity/target_qty_entity.dart';
import 'package:prominous/features/domain/repository/target_qty_repo.dart';

class TargetQtyUsecase {
  final TargetQtyRepository targetQtyRepository;
  TargetQtyUsecase(this.targetQtyRepository);

  Future<TargetQtyEntity> execute ( int paid,int deptid,int psid,int pwsid, String token, int orgid) {
    
    return targetQtyRepository.getTargetQty(paid, deptid, psid, pwsid, token,  orgid);
  }
}
