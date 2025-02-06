import 'package:prominous/features/domain/entity/non_production_activity_entity.dart';

abstract class NonProductionRepository {

  Future<NonProductionActivityEntity> getNonProductionActivity (String token, int orgid);
}