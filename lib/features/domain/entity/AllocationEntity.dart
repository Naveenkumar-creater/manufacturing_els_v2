// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:prominous/features/data/model/allocation_model.dart';

class AllocationEntity extends Equatable {
  final List<AllocationList>? allocationEntity;
  const AllocationEntity({this.allocationEntity});

  @override
  List<Object?> get props => [allocationEntity];
}

class AllocationList extends Equatable {
  const AllocationList({
    // required this.productid,
    required this.processid,
    // required this.productname,
    required this.processname,
  });
  // final int? productid;
  final int? processid;
  // final String? productname;
  final String? processname;
  @override
  List<Object?> get props => [ processid, processname];
}
