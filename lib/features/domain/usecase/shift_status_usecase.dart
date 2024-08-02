import 'package:prominous/features/domain/entity/shift_status_entity.dart';
import 'package:prominous/features/domain/repository/shift_status_repo.dart';

class ShiftStatusUsecase {
  final ShiftStatusRepository shiftStatusRepository;

  ShiftStatusUsecase(this.shiftStatusRepository);

  Future<ShiftStatusEntity> execute(int deptid,int processid, String token) {
    return shiftStatusRepository.getShiftStatus(deptid,processid, token);
  }
}