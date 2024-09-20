import 'package:prominous/features/domain/entity/non_production_activity_entity.dart';
import 'package:prominous/features/domain/repository/non_production_repo.dart';

class NonProductionUsecase {
  final NonProductionRepository nonProductionRepository;
  NonProductionUsecase(this.nonProductionRepository);

  Future<NonProductionActivityEntity> execute(
    String token,
  ) async {
    return nonProductionRepository.getNonProductionActivity(token);
  }
}
