import 'package:prominous/features/domain/entity/AllocationEntity.dart';

abstract class AllocationRepository {
  Future<AllocationEntity> getallocation(int id,int deptid, String token);
}
