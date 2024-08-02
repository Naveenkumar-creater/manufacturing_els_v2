import 'package:prominous/features/domain/entity/AllocationEntity.dart';
import 'package:prominous/features/domain/repository/allocation_repo.dart';

class AllocationUsecases {
  final AllocationRepository allocationRepository;

  AllocationUsecases(this.allocationRepository);

  Future<AllocationEntity> execute(int id, int deptid,String token) {
    return allocationRepository.getallocation(id,deptid, token);
  }
}
