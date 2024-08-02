import 'package:equatable/equatable.dart';

class ProcessEntity extends Equatable {
  final List<ListofProcessEntity>? listofProcessEntity;

  const ProcessEntity({
    this.listofProcessEntity,
  });

  @override
  List<Object?> get props => [listofProcessEntity];
}

class ListofProcessEntity extends Equatable {
  const ListofProcessEntity(
      {required this.mpmCapability,
      required this.mpmBatchProcess,
      required this.processName,
      required this.processId,
      required this.deptId,
      required this.shiftgroupId});

  final int? mpmCapability;
  final int? processId;
  final String? processName;
  final int? shiftgroupId;
  final int? deptId;
  final int? mpmBatchProcess;
  @override
  List<Object?> get props => [processName, processId, deptId, shiftgroupId];
}
